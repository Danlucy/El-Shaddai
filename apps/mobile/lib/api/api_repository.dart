import 'dart:convert';

import 'package:dio/dio.dart';
import '../core/constants/constants.dart';
import 'api_interceptor.dart';
import 'models/zoom_meeting_model/zoom_meeting_model.dart';

class ApiRepository {
  String getEncodedString() {
    String combinedString = '$clientId:$clientSecret';
    String encodedString = base64.encode(utf8.encode(combinedString));
    return encodedString;
  }

  final _authDio = Dio();
  final _functionDio = Dio()..interceptors.add(CustomInterceptor());
  Future<Response> getAccessToken(String code, String codeVerifier) async {
    final String encodedString = getEncodedString();
    try {
      final response = await _authDio.post(
        'https://zoom.us/oauth/token',
        data: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': 'https://daniel-ong.com',
          'code_verifier': codeVerifier,
        },
        options: Options(
          headers: {
            'Authorization': 'Basic $encodedString',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );
      if (response.statusCode == 200) {
        return response; // Dio automatically parses JSON response
      } else {
        throw Exception(
            'Failed to exchange authorization code: ${response.data}');
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

  Future<Response> createMeeting(
    ZoomMeetingModel meetingData,
    String accessToken,
  ) {
    return _functionDio.post('https://api.zoom.us/v2/users/me/meetings',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
        data: meetingData.toJson());
  }

  Future<Map<String, dynamic>> exchangeAuthorizationCode(
      String authorizationCode, String codeVerifier) async {
    final Dio dio = Dio();

    try {
      final response = await dio.post(
        'https://zoom.us/oauth/token',
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
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
            'Failed to exchange authorization code: ${response.data}');
      }
    } catch (e) {
      print('Error during token exchange: $e');
      throw Exception('Error exchanging authorization code');
    }
  }
}
