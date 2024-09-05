import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:el_shaddai/api/api_interceptor.dart';
import 'package:el_shaddai/core/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiRepository {
  String getEncodedString() {
    String combinedString = '$clientId:$clientSecret';
    String encodedString = base64.encode(utf8.encode(combinedString));
    return encodedString;
  }

  final _dio = Dio();

  Future<Response> getAccessToken(BuildContext context, String code) {
    _dio.interceptors.add(CustomInterceptor(context: context));
    final String encodedString = getEncodedString();
    return _dio.post(
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

  Future<Response> refreshToken(String refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedString = getEncodedString();
    return _dio
        .post(
      'https://zoom.us/oauth/token',
      data: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
      },
      options: Options(
        headers: {
          'Authorization': 'Basic $encodedString',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    )
        .then((response) async {
      Map<String, dynamic> accessTokenData = {
        "token": response.data['access_token'],
        'refresh_token': response.data['refresh_token'],
        "duration": DateTime.now()
            .add(Duration(seconds: response.data['expires_in']))
            .toIso8601String(),
      };
      String encodedMap = json.encode(accessTokenData);
      await prefs.setString('accessToken', encodedMap);
      print('REFRESGHING');
      return response;
    });
  }

  Future<Response> getUser(String accessToken, BuildContext context) {
    _dio.interceptors.add(CustomInterceptor(context: context));
    return _dio.get('https://api.zoom.us/v2/users/me',
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }));
  }
}
