import 'package:cloud_functions/cloud_functions.dart';
import 'package:constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Future<Response<dynamic>> requestZoomToken(
  Dio dio,
  Map<String, dynamic> data,
  Options options,
) async {
  if (kIsWeb) {
    try {
      final payload = Map<String, dynamic>.from(data);
      if (!payload.containsKey('client_id')) {
        payload['client_id'] = clientId;
      }
      final response = await FirebaseFunctions.instanceFor(region: 'asia-southeast1')
          .httpsCallable('zoomOAuthToken')
          .call<Map<String, dynamic>>(payload);
      return Response(
        requestOptions: RequestOptions(path: 'zoomOAuthToken'),
        statusCode: 200,
        data: response.data,
      );
    } catch (_) {
      // Fall through to direct request if Cloud Function is unavailable or throws
    }
  }
  return dio.post('https://zoom.us/oauth/token', data: data, options: options);
}
