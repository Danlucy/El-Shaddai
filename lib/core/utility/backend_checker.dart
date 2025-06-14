import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class BackendChecker {
  static bool isBackendAvailable = true;

  /// Comprehensive connectivity check
  static Future<bool> checkConnectivity() async {
    // First: Quick internet check
    if (!await _hasBasicInternet()) {
      return false;
    }

    // Second: Verify Firebase is reachable
    return await _canReachFirebase();
  }

  /// Basic internet connectivity check
  static Future<bool> _hasBasicInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Check if Firebase services are accessible
  static Future<bool> _canReachFirebase() async {
    try {
      // Try to access Firestore with a timeout
      await FirebaseFirestore.instance
          .collection('test')
          .limit(1)
          .get()
          .timeout(const Duration(seconds: 5));
      return true;
    } catch (e) {
      print('Firebase check failed: $e');
      return false;
    }
  }
}
