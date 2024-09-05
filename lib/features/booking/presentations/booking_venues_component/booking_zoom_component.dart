import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dio/dio.dart';
import 'package:el_shaddai/api/api_repository.dart';
import 'package:el_shaddai/core/constants/constants.dart';
import 'package:el_shaddai/core/router/router.dart';
import 'package:el_shaddai/features/auth/presentations/zoom_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingZoomComponent extends ConsumerStatefulWidget {
  @override
  _BookingZoomComponentState createState() => _BookingZoomComponentState();
}

class _BookingZoomComponentState extends ConsumerState<BookingZoomComponent> {
  final ValueNotifier<String?> userAuthenticationToken =
      ValueNotifier<String?>(null);

  @override
  void initState() {
    super.initState();
    _loadUserAuthenticationToken();
    _startTokenListener();
  }

  Future<void> _loadUserAuthenticationToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userAuthenticationToken.value = prefs.getString('userAuthenticationCode');
  }

  void _startTokenListener() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Periodically check for changes in the token
    while (true) {
      await Future.delayed(
          Duration(seconds: 5)); // Adjust the interval as needed
      String? newToken = prefs.getString('userAuthenticationCode');
      if (newToken != userAuthenticationToken.value) {
        userAuthenticationToken.value = newToken; // Update the notifier
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ApiRepository apiRepository = ApiRepository();
    return Column(
      children: [
        ValueListenableBuilder<String?>(
          valueListenable: userAuthenticationToken,
          builder: (context, token, child) {
            return Column(
              children: [
                if (token == null) // If token is null, show the button
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        ZoomRoute(zoomLoginRoute).push(context);
                      } catch (e, s) {
                        print(s);
                        print('Error getting authorization code: $e $s');
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Image.asset(
                        'assets/logo/zoom.png',
                        width: 150,
                        height: 30,
                      ),
                    ),
                  ),
                IconButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? decodedMap = prefs.getString('accessToken');
                    Map<String, dynamic> accesTokenData =
                        json.decode(decodedMap!);

                    String token = accesTokenData['token'];
                    print(token);
                    final dad = apiRepository.getUser(token, context);
                    dad.then(
                      (value) => print(value),
                    );
                  },
                  icon: Icon(Icons.access_alarm),
                ),
                TextButton(
                    onPressed: () async {
                      // SharedPreferences prefs =
                      //     await SharedPreferences.getInstance();
                      // String? decodedMap = prefs.getString('accessToken');
                      //
                      // Map<String, dynamic> accesTokenData =
                      //     json.decode(decodedMap!);
                      // String refreshToken = accesTokenData['refresh_token'];
                      // print(refreshToken);
                      // final Future<Response> d =
                      //     apiRepository.refreshToken(refreshToken);
                      // d.then(
                      //   (value) {
                      //     print(value);
                      //   },
                      // );
                    },
                    child: Text('accestoken')),
                TextButton(
                    onPressed: () async {
                      // SharedPreferences prefs =
                      //     await SharedPreferences.getInstance();
                      // String? decodedMap = prefs.getString('accessToken');
                      // Map<String, dynamic> accesTokenData =
                      //     json.decode(decodedMap!);
                      //
                      // String token = accesTokenData['duration'];
                      // print(token);
                      //
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? newToken =
                          prefs.getString('userAuthenticationCode');
                      print(newToken);
                      // Set<String> keys = prefs.getKeys();
                      //
                      // for (String key in keys) {
                      //   dynamic value = prefs.get(key);
                      //   print('Key: $key, Value: $value');
                      // }
                    },
                    child: Text('dadadad')),
                if (token == null) // Optionally show the token
                  Text('Token: $token'),
              ],
            );
          },
        ),
      ],
    );
  }
}
