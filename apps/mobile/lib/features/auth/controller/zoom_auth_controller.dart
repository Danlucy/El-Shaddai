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
    startTokenListener();
  }

  void startTokenListener() {
    // 1. Create the timer
    final timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      // 2. IMPORTANT: Check if the provider is still mounted before doing async work
      if (!ref.mounted) {
        timer.cancel();
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? newToken = prefs.getString('userAuthenticationCode');

      // 3. Check ref.mounted AGAIN after the async gap (await)
      if (ref.mounted && newToken != state) {
        state = newToken;
      }
    });

    // 4. Register the disposal logic immediately
    ref.onDispose(() {
      timer.cancel();
    });

    // Optional: your existing auto-cancel after 2 minutes
    Future.delayed(const Duration(minutes: 2), () {
      if (timer.isActive) timer.cancel();
    });
  }
}
