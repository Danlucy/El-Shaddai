import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PKCEUtils {
  // Generate a random code verifier
  static String generateCodeVerifier({int length = 128}) {
    const String chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final Random random = Random.secure();
    return List.generate(length, (_) => chars[random.nextInt(chars.length)])
        .join();
  }

  // Generate the code challenge from the code verifier
  static String generateCodeChallenge(String codeVerifier) {
    final bytes = utf8.encode(codeVerifier);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }

  Future<void> saveCodeVerifier(String codeVerifier) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('codeVerifier', codeVerifier);
    print('Code Verifier saved: $codeVerifier');
  }
}
