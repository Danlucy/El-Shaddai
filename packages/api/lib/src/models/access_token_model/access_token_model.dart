import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'access_token_model.freezed.dart';
part 'access_token_model.g.dart';

@freezed
class AccessToken with _$AccessToken {
  AccessToken({
    required this.token,
    required this.refreshToken,
    required this.duration,
  });
  final String token;
  final String refreshToken;
  final DateTime duration;
}

@riverpod
class AccessTokenNotifier extends _$AccessTokenNotifier {
  @override
  Future<AccessToken?> build() {
    return _loadAccessToken();
  }

  Future<AccessToken?> _loadAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? decodedMap = prefs.getString('accessToken');

    if (decodedMap != null) {
      return AccessToken.fromJson(json.decode(decodedMap));
    }
    return null;
  }

  Future<void> saveAccessToken(AccessToken accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', json.encode(accessToken.toJson()));
    state = AsyncValue.data(accessToken);
    // Update the state
  }

  Future<void> clearAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    state = const AsyncValue.data(null);
    // Clear the state
  }
}
