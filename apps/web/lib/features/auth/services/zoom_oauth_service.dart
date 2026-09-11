import 'dart:async';
import 'dart:js_interop';

import 'package:api/api.dart';
import 'package:constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

import '../../../api/pkce_utils.dart';

class ZoomOAuthException implements Exception {
  const ZoomOAuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ZoomOAuthService {
  ZoomOAuthService({ApiRepository? apiRepository})
    : _apiRepository = apiRepository ?? ApiRepository();

  static const _callbackOrigin = 'https://daniel-ong.com';

  final ApiRepository _apiRepository;

  Future<String> _authenticateWeb(Uri authorizationUrl) {
    final completer = Completer<String>();
    StreamSubscription<web.MessageEvent>? messageSubscription;
    Timer? timeoutTimer;
    Timer? popupClosedTimer;

    void cleanup() {
      messageSubscription?.cancel();
      timeoutTimer?.cancel();
      popupClosedTimer?.cancel();
    }

    messageSubscription = web.window.onMessage.listen((web.MessageEvent event) {
      if (event.origin != _callbackOrigin) return;

      String? callbackUrl;
      final data = event.data.dartify();
      if (data is String) {
        callbackUrl = data;
      } else if (data is Map) {
        callbackUrl = data['flutter-web-auth-2'] as String?;
      }

      if (callbackUrl != null && callbackUrl.contains('code=')) {
        debugPrint('[ZoomOAuth] Received callback with code: $callbackUrl');
        cleanup();
        if (!completer.isCompleted) {
          completer.complete(callbackUrl);
        }
      }
    });

    debugPrint('[ZoomOAuth] Opening authorization URL: $authorizationUrl');
    final popup = web.window.open(
      authorizationUrl.toString(),
      'ZoomOAuth',
      'width=600,height=750,menubar=no,toolbar=no,status=no',
    );

    if (popup == null) {
      cleanup();
      throw const ZoomOAuthException(
        'Popup was blocked by the browser. Please allow popups for this site.',
      );
    }

    popupClosedTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (popup.closed) {
        cleanup();
        if (!completer.isCompleted) {
          completer.completeError(
            const ZoomOAuthException('Zoom sign-in was cancelled.'),
          );
        }
      }
    });

    timeoutTimer = Timer(const Duration(minutes: 3), () {
      cleanup();
      if (!completer.isCompleted) {
        completer.completeError(
          const ZoomOAuthException('Zoom sign-in timed out. Please try again.'),
        );
      }
    });

    return completer.future;
  }

  Future<AccessToken> signIn() async {
    final codeVerifier = PKCEUtils.generateCodeVerifier();
    final codeChallenge = PKCEUtils.generateCodeChallenge(codeVerifier);
    final state = PKCEUtils.generateCodeVerifier(length: 48);

    final authorizationUrl = Uri.parse(zoomLoginBaseUrl).replace(
      queryParameters: {
        'response_type': 'code',
        'client_id': clientId,
        'redirect_uri': redirectUrl,
        'code_challenge': codeChallenge,
        'code_challenge_method': 'S256',
        'state': state,
      },
    );

    final callbackUrl = await _authenticateWeb(authorizationUrl);

    final callback = Uri.parse(callbackUrl);
    final oauthError = callback.queryParameters['error'];
    if (oauthError != null) {
      final description =
          callback.queryParameters['error_description'] ?? oauthError;
      throw ZoomOAuthException('Zoom authorization failed: $description');
    }

    if (callback.queryParameters['state'] != state) {
      throw const ZoomOAuthException(
        'Zoom authorization could not be verified. Please try again.',
      );
    }

    final code = callback.queryParameters['code'];
    if (code == null || code.isEmpty) {
      throw const ZoomOAuthException(
        'Zoom did not return an authorization code.',
      );
    }

    final actualRedirect = '${callback.scheme}://${callback.host}${callback.path}';
    final tokenRedirectUri = actualRedirect.startsWith(_callbackOrigin)
        ? actualRedirect
        : redirectUrl;
    debugPrint('[ZoomOAuth] Exchanging code with redirectUri: $tokenRedirectUri');

    final response = await _apiRepository.getAccessToken(
      code,
      codeVerifier,
      redirectUri: tokenRedirectUri,
    );
    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw const ZoomOAuthException(
        'Zoom returned an invalid token response.',
      );
    }

    final token = data['access_token'];
    final refreshToken = data['refresh_token'];
    final expiresIn = data['expires_in'];

    if (token is! String || refreshToken is! String || expiresIn is! num) {
      throw const ZoomOAuthException(
        'Zoom returned incomplete login credentials.',
      );
    }

    return AccessToken(
      token: token,
      refreshToken: refreshToken,
      duration: DateTime.now().add(Duration(seconds: expiresIn.toInt())),
    );
  }
}
