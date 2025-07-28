import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

/// Handles backend connectivity and Firebase availability checks.
class Backend {
  Backend._(); // Prevent instantiation

  /// Checks if device has internet access (e.g. can reach Google).
  static Future<bool> checkInternetAccess() async {
    final r = const RetryOptions(
      maxAttempts: 3,
      delayFactor: Duration(seconds: 1),
      maxDelay: Duration(seconds: 10),
    );

    try {
      return await r.retry(
        () async {
          if (!await _hasBasicInternet()) {
            throw const SocketException('No internet connection');
          }
          return true;
        },
        retryIf: (e) => e is SocketException || e is TimeoutException,
        onRetry: (e) => print('Retrying internet check due to: $e'),
      );
    } catch (e) {
      print('Final internet check failed: $e');
      return false;
    }
  }

  /// Checks if Firebase Firestore is accessible (optional).
  static Future<bool> checkFirebaseAvailability() async {
    try {
      await FirebaseFirestore.instance
          .collection('healthCheck')
          .doc('status')
          .get()
          .timeout(const Duration(seconds: 7));
      return true;
    } on FirebaseException catch (e) {
      print('Firebase Check Failed: ${e.code} - ${e.message}');
      // Don't treat permission errors as a connectivity issue
      return !(e.code == 'permission-denied' || e.code == 'not-found');
    } on TimeoutException {
      print('Firebase Check Timeout');
      return false;
    } catch (e) {
      print('Unexpected Firebase error: $e');
      return false;
    }
  }

  /// Internal method to test HTTP connectivity using Google’s generate_204
  static Future<bool> _hasBasicInternet() async {
    try {
      final response = await http
          .head(Uri.parse('https://www.google.com/generate_204'))
          .timeout(Duration(seconds: 5));
      return response.statusCode == 204;
    } on SocketException catch (e) {
      print('Internet Check: SocketException - ${e.message}');
      rethrow;
    } on TimeoutException {
      print('Internet Check: TimeoutException');
      rethrow;
    } catch (e) {
      print('Internet Check: Unknown error - $e');
      rethrow;
    }
  }
}
