import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:dio/dio.dart';
import 'package:el_shaddai/api/api_repository.dart';
import 'package:el_shaddai/core/constants/constants.dart';
import 'package:el_shaddai/core/router/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomInterceptor extends Interceptor {
  final BuildContext context;
  final ApiRepository apiRepository = ApiRepository();

  CustomInterceptor({required this.context});
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? decodedMap = prefs.getString('accessToken');

    Map<String, dynamic> accessTokenData = json.decode(decodedMap!);
    if (DateTime.now().isAfter(DateTime.parse(accessTokenData['duration']))) {
      await apiRepository.refreshToken(accessTokenData['refresh_token']);
      print('ADAWDAWD');
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Do something with response data
    print('Response received from ${response.requestOptions.uri}');
    handler.next(response);
  }

  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if the user is unauthorized.
    if (err.response?.statusCode == 401) {
      // Refresh the user's authentication token.
      try {
        const ZoomRoute(zoomLoginRoute).push(context);
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

  // Future refreshAccessToken() {
  //
  // }
  // Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
  //   // Create a new `RequestOptions` object with the same method, path, data, and query parameters as the original request.
  //   final options = Options(
  //     method: requestOptions.method,
  //     headers: {
  //       "Authorization": "Bearer ${token}",
  //     },
  //   );
  //
  //   // Retry the request with the new `RequestOptions` object.
  //   return dio.request<dynamic>(requestOptions.path,
  //       data: requestOptions.data,
  //       queryParameters: requestOptions.queryParameters,
  //       options: options);
  // }
}
