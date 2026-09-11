import 'dart:convert';
import 'dart:typed_data';

import 'package:api/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:website/features/auth/services/zoom_oauth_service.dart';

class TokenAdapter implements HttpClientAdapter {
  late RequestOptions request;
  late Map<String, String> body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;
    final bytes = await requestStream!.expand((chunk) => chunk).toList();
    body = Uri.splitQueryString(utf8.decode(bytes));
    return ResponseBody.fromString(
      jsonEncode({
        'access_token': 'test-token',
        'refresh_token': 'next-refresh',
        'expires_in': 3600,
      }),
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'PKCE exchange sends client ID and verifier without a client secret',
    () async {
      final adapter = TokenAdapter();
      final dio = Dio()..httpClientAdapter = adapter;
      await ApiRepository(authDio: dio).getAccessToken(
        'code',
        'verifier',
        redirectUri: 'http://127.0.0.1:7537/auth.html',
        publicClientId: 'public-id',
      );
      final body = adapter.body;
      expect(body['client_id'], 'public-id');
      expect(body['code_verifier'], 'verifier');
      expect(body['redirect_uri'], 'http://127.0.0.1:7537/auth.html');
      expect(adapter.request.headers.containsKey('Authorization'), isFalse);
    },
  );

  test(
    'existing confidential exchange still uses Basic authentication',
    () async {
      final adapter = TokenAdapter();
      await ApiRepository(
        authDio: Dio()..httpClientAdapter = adapter,
      ).getAccessToken('code', 'verifier');
      expect(adapter.request.headers['Authorization'], startsWith('Basic '));
      expect(
        adapter.body.containsKey('client_id'),
        isFalse,
      );
    },
  );

  test('public token refresh retains its client ID in storage', () async {
    SharedPreferences.setMockInitialValues({});
    final adapter = TokenAdapter();
    await CustomInterceptor(
      tokenDio: Dio()..httpClientAdapter = adapter,
    ).refreshToken(
      'old-refresh',
      RequestOptions(path: '/meetings'),
      publicClientId: 'public-id',
    );
    final body = adapter.body;
    expect(body['client_id'], 'public-id');
    expect(body['grant_type'], 'refresh_token');
    expect(adapter.request.headers.containsKey('Authorization'), isFalse);
    final prefs = await SharedPreferences.getInstance();
    final saved = AccessToken.fromJson(
      jsonDecode(prefs.getString('accessToken')!),
    );
    expect(saved.publicClientId, 'public-id');
    expect(saved.refreshToken, 'next-refresh');
  });

  test('old mobile token JSON remains compatible', () {
    final token = AccessToken.fromJson({
      'token': 'old-token',
      'refreshToken': 'old-refresh',
      'duration': '2026-09-11T12:00:00.000',
    });
    expect(token.publicClientId, isNull);
    final publicToken = token.copyWith(publicClientId: 'public-id');
    expect(
      AccessToken.fromJson(publicToken.toJson()).publicClientId,
      'public-id',
    );
  });
}
