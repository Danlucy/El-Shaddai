import 'package:flutter_test/flutter_test.dart';
import 'package:website/api/pkce_utils.dart';

void main() {
  group('PKCEUtils', () {
    test('generates a verifier with valid length and characters', () {
      final verifier = PKCEUtils.generateCodeVerifier();

      expect(verifier, hasLength(128));
      expect(RegExp(r'^[A-Za-z0-9\-._~]+$').hasMatch(verifier), isTrue);
    });

    test('generates the RFC 7636 S256 challenge', () {
      const verifier = 'dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk';

      expect(
        PKCEUtils.generateCodeChallenge(verifier),
        'E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM',
      );
    });
  });
}
