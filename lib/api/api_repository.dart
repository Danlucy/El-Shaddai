import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:el_shaddai/api/api_interceptor.dart';
import 'package:el_shaddai/api/models/zoom_meeting_model/zoom_meeting_model.dart';
import 'package:el_shaddai/core/constants/constants.dart';
import 'package:flutter/material.dart';

class ApiRepository {
  String getEncodedString() {
    String combinedString = '$clientId:$clientSecret';
    String encodedString = base64.encode(utf8.encode(combinedString));
    return encodedString;
  }

  final _authDio = Dio();
  final _functionDio = Dio()..interceptors.add(CustomInterceptor());
  Future<Response> getAccessToken(BuildContext context, String code) {
    final String encodedString = getEncodedString();
    return _authDio.post(
      'https://zoom.us/oauth/token',
      data: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': 'https://catboy123example.com',
      },
      options: Options(
        headers: {
          'Authorization': 'Basic $encodedString',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    );
  }

  Future<Response> getUser(String accessToken, BuildContext context) {
    return _functionDio.get('https://api.zoom.us/v2/users/me',
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }));
  }

  Future<Response> createMeeting(
    ZoomMeetingModel meetingData,
    String accessToken,
  ) {
    print('CREATING');
    return _functionDio.post('https://api.zoom.us/v2/users/me/meetings',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
        data: meetingData.toJson());
  }
}
