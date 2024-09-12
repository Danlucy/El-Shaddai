import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:el_shaddai/core/constants/constants.dart';
import 'package:el_shaddai/core/router/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomInterceptor extends Interceptor {
  String getEncodedString() {
    String combinedString = '$clientId:$clientSecret';
    String encodedString = base64.encode(utf8.encode(combinedString));
    return encodedString;
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? decodedMap = prefs.getString('accessToken');
    Map<String, dynamic> accessTokenData = json.decode(decodedMap!);

    if (DateTime.now().isAfter(DateTime.parse(accessTokenData['duration']))) {
      await refreshToken(
        accessTokenData['refreshToken'],
        options,
      );
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Do something with response data
    print('Response received from ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if the user is unauthorized.
    print(err.response?.statusCode);
    print(err.response?.data);
    print(err.message);
    if (err.response?.statusCode == 401) {
      print('dad');
      // Refresh the user's authentication token.
      try {
        const ZoomRoute(zoomLoginRoute).push(navigatorKey.currentContext!);
      } catch (e, s) {
        print('Error getting authorization code: $e $s');
      }
      // Retry the request.
      try {
        // handler.resolve(await _retry(err.requestOptions));
      } on DioException catch (e) {
        // If the request fails again, pass the error to the next interceptor in the chain.
        handler.next(e);
      }
      // Return to prevent the next interceptor in the chain from being executed.
      return;
    }
    // Pass the error to the next interceptor in the chain.
    handler.next(err);
  }

  Future<Response> refreshToken(
    String refreshToken,
    RequestOptions options,
  ) async {
    final Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedString = getEncodedString();
    return dio
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
      options.headers['Authorization'] =
          'Bearer ${response.data['access_token']}';
      Map<String, dynamic> accessTokenData = {
        "token": response.data['access_token'],
        'refresh_token': response.data['refresh_token'],
        "duration": DateTime.now()
            .add(Duration(seconds: response.data['expires_in']))
            .toIso8601String(),
      };
      String encodedMap = json.encode(accessTokenData);
      await prefs.setString('accessToken', encodedMap);
      return response;
    });
  }
}
