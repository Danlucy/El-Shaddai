import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'zoom_auth_controller.g.dart';

@riverpod
class AuthTokenNotifier extends _$AuthTokenNotifier {
  @override
  String? build() {
    _loadToken();
    return null; // Initial state: no token
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    state = prefs.getString('userAuthenticationCode');

    // Start listening for token changes
    _startTokenListener();
  }

  void _startTokenListener() {
    // Start a periodic timer that checks for token changes every 2 seconds
    Timer timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? newToken = prefs.getString('userAuthenticationCode');

      if (newToken != state) {
        state = newToken; // Update the state
      }
    });

    // Stop the timer after 1 minute
    Future.delayed(const Duration(minutes: 2), () {
      timer.cancel(); // Cancel the periodic timer
    });
  }
}
