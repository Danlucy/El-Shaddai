import 'dart:convert';

import 'package:api/api.dart';
import 'package:constants/constants.dart';
import 'package:dio/dio.dart';
import 'zoom_token_transport.dart';

class ApiRepository {
  ApiRepository({Dio? authDio}) : _authDio = authDio ?? Dio();

  String getEncodedString() {
    String combinedString = '$clientId:$clientSecret';
    String encodedString = base64.encode(utf8.encode(combinedString));
    return encodedString;
  }

  final Dio _authDio;
  final _functionDio = Dio()..interceptors.add(CustomInterceptor());
  Future<Response> getAccessToken(
    String code,
    String codeVerifier, {
    String redirectUri = redirectUrl,
    String? publicClientId,
  }) async {
    final String encodedString = getEncodedString();
    try {
      final response = await requestZoomToken(
        _authDio,
        {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': redirectUri,
          'code_verifier': codeVerifier,
          if (publicClientId != null) 'client_id': publicClientId,
        },
        Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            if (publicClientId == null) 'Authorization': 'Basic $encodedString',
          },
        ),
      );
      if (response.statusCode == 200) {
        return response; // Dio automatically parses JSON response
      } else {
        throw Exception(
          'Failed to exchange authorization code: ${response.data}',
        );
      }
    } catch (e) {
      throw Exception('Error exchanging authorization code $e');
    }
  }

  // Future<Response> getUser(String accessToken, BuildContext context) {
  //   return _functionDio.get('https://api.zoom.us/v2/users/me',
  //       options: Options(headers: {
  //         'Authorization': 'Bearer $accessToken',
  //       }));
  // }

  Future<Response> createMeeting(ZoomMeetingModel meetingData) async {
    print('josn data $meetingData');
    final response = await _functionDio.post(
      'https://api.zoom.us/v2/users/me/meetings',
      data: meetingData.toApiPayload(),
    );

    print('Getting Meeting Response:');
    print(response);

    return response;
  }

  Future<Map<String, dynamic>> exchangeAuthorizationCode(
    String authorizationCode,
    String codeVerifier,
  ) async {
    final Dio dio = Dio();

    try {
      final response = await dio.post(
        'https://zoom.us/oauth/token',
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
          },
        ),
        data: {
          'grant_type': 'authorization_code',
          'code': authorizationCode,
          'redirect_uri': redirectUrl,
          'code_verifier': codeVerifier,
        },
      );

      // Check for success
      if (response.statusCode == 200) {
        return response.data; // Dio automatically parses JSON response
      } else {
        throw Exception(
          'Failed to exchange authorization code: ${response.data}',
        );
      }
    } catch (e) {
      throw Exception('Error exchanging authorization code');
    }
  }
}
