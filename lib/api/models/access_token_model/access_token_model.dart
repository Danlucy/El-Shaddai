import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'access_token_model.g.dart';

part 'access_token_model.freezed.dart';

@freezed
class AccessToken with _$AccessToken {
  const factory AccessToken({
    required String token,
    required String refreshToken,
    required DateTime duration,
  }) = _AccessToken;

  factory AccessToken.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenFromJson(json);
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
    print("DAWDAWD");
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
