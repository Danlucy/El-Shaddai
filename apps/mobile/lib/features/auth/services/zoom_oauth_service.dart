import 'package:api/api.dart';
import 'package:constants/constants.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

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

  static const _callbackScheme = 'https';
  static const _callbackHost = 'daniel-ong.com';
  static const _callbackPath = '/zoom-login-successful/';

  final ApiRepository _apiRepository;

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

    final callbackUrl = await FlutterWebAuth2.authenticate(
      url: authorizationUrl.toString(),
      callbackUrlScheme: _callbackScheme,
      options: const FlutterWebAuth2Options(
        httpsHost: _callbackHost,
        httpsPath: _callbackPath,
      ),
    );

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

    final response = await _apiRepository.getAccessToken(code, codeVerifier);
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
