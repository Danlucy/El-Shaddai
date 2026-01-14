import 'dart:convert';

import 'package:constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomInterceptor extends Interceptor {
  String getEncodedString() {
    String combinedString = '$clientId:$clientSecret';
    String encodedString = base64.encode(utf8.encode(combinedString));
    return encodedString;
  }

  /// Opens Zoom OAuth login in the default browser
  Future<void> _openZoomLoginInBrowser() async {
    // Construct the Zoom OAuth URL
    final Uri zoomAuthUrl = Uri.parse(
      zoomLoginRoute,
      // Make sure redirectUri is defined in constants
    );

    try {
      if (await canLaunchUrl(zoomAuthUrl)) {
        await launchUrl(
          zoomAuthUrl,
          mode: LaunchMode.externalApplication, // Opens in default browser
        );
        if (kDebugMode) {
          print('Opened Zoom login in browser');
        }
      } else {
        if (kDebugMode) {
          print('Could not launch Zoom login URL');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error launching Zoom login: $e');
      }
    }
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? decodedMap = prefs.getString('accessToken');

    if (decodedMap == null) return handler.next(options);

    try {
      Map<String, dynamic> accessTokenData = json.decode(decodedMap);
      DateTime expiry = DateTime.parse(accessTokenData['duration']);

      String token = accessTokenData['token'];

      if (DateTime.now().isAfter(expiry)) {
        // Refresh logic
        final response = await refreshToken(
          accessTokenData['refreshToken'],
          options,
        );
        token = response.data['access_token'];
      }

      // Set the token for EVERY request handled by this Dio instance
      options.headers['Authorization'] = 'Bearer $token';
    } catch (e) {
      if (kDebugMode) print('Error in interceptor: $e');
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) {
      print('Request error - Status: ${err.response?.statusCode}');
      print('Response data: ${err.response?.data}');
      print('Error message: ${err.message}');
    }

    // Check if the user is unauthorized
    if (err.response?.statusCode == 401 || err.response?.statusCode == 400) {
      if (kDebugMode) {
        print('Authentication failed, opening Zoom login in browser');
      }

      try {
        // Open Zoom login in default browser instead of navigating in-app
        await _openZoomLoginInBrowser();
      } catch (e, s) {
        if (kDebugMode) {
          print('Error opening browser for login: $e');
          print('Stack trace: $s');
        }
      }

      // Don't retry the request, just pass the error
      handler.next(err);
      return;
    }

    // Pass the error to the next interceptor in the chain
    handler.next(err);
  }

  Future<Response> refreshToken(
    String refreshToken,
    RequestOptions options,
  ) async {
    try {
      if (kDebugMode) {
        print('Attempting to refresh tokens');
      }

      final Dio dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String encodedString = getEncodedString();

      final response = await dio.post(
        'https://zoom.us/oauth/token',
        data: {'grant_type': 'refresh_token', 'refresh_token': refreshToken},
        options: Options(
          headers: {
            'Authorization': 'Basic $encodedString',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.data['refresh_token'] == null) {
        throw Exception(
          'Failed to refresh token - no refresh token in response',
        );
      }

      if (kDebugMode) {
        print('Token refresh successful');
      }

      // Update the request options with new token
      options.headers['Authorization'] =
          'Bearer ${response.data['access_token']}';

      // Save new tokens to SharedPreferences
      Map<String, dynamic> accessTokenData = {
        "token": response.data['access_token'],
        'refreshToken': response.data['refresh_token'],
        "duration": DateTime.now()
            .add(Duration(seconds: response.data['expires_in']))
            .toIso8601String(),
      };

      String encodedMap = json.encode(accessTokenData);
      await prefs.setString('accessToken', encodedMap);

      return response;
    } catch (e, s) {
      if (kDebugMode) {
        print('Failed to refresh token: $e');
        print('Stack trace: $s');
      }

      // Open browser for re-authentication
      await _openZoomLoginInBrowser();

      throw Exception('Failed to refresh token: $e');
    }
  }
}
