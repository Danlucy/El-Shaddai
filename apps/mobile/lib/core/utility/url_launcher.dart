import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String link) async {
  final Uri url = Uri.parse(Uri.encodeFull(link.trim()));

  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}

String parseZoomId(String? web) {
  if (web == null || web.isEmpty) return '';
  final parts = web.split('/');
  return parts.isNotEmpty ? parts[0] : '';
}

String? parsePassword(String? web) {
  if (web == null || web.isEmpty) return null;
  final parts = web.split('/');
  return parts.length > 1 ? parts[1] : null; // Returns null if no password part
}

// Builds the internal 'ID/PASSWORD' string
String buildInternalWebString(String zoomId, String? password) {
  if (password != null && password.isNotEmpty) {
    return '$zoomId/$password';
  }
  return zoomId;
}

// --- NEW HELPER: Builds the external, full Zoom URL (ONLY for booking) ---
String buildExternalZoomUrl(String zoomId) {
  if (zoomId.isEmpty) return ''; // A Zoom URL must have an ID
  String baseUrl = 'https://zoom.us/j/$zoomId';

  return baseUrl;
}

String parseZoomIdFromUrl(String? fullZoomUrl) {
  if (fullZoomUrl == null || fullZoomUrl.isEmpty) return '';
  try {
    final uri = Uri.parse(fullZoomUrl);
    // Zoom meeting IDs are typically the last path segment after '/j/'
    final pathSegments = uri.pathSegments;
    if (pathSegments.isNotEmpty) {
      // Find the index of 'j' and return the next segment
      final jIndex = pathSegments.indexOf('j');
      if (jIndex != -1 && jIndex + 1 < pathSegments.length) {
        return pathSegments[jIndex + 1];
      }
      // Fallback: If no 'j' or malformed, but still last segment is digits
      if (RegExp(r'^\d+$').hasMatch(pathSegments.last)) {
        return pathSegments.last;
      }
    }
  } catch (e) {
    debugPrint('Error parsing Zoom ID from URL: $fullZoomUrl - $e');
  }
  return '';
}

/// Parses a Zoom Meeting Password from a full Zoom join URL.
/// Example: https://zoom.us/j/84646468664?pwd=egsyeydyd -> "egsyeydyd"
String? parsePasswordFromUrl(String? fullZoomUrl) {
  if (fullZoomUrl == null || fullZoomUrl.isEmpty) return null;
  try {
    final uri = Uri.parse(fullZoomUrl);
    return uri
        .queryParameters['pwd']; // Get password from 'pwd' query parameter
  } catch (e) {
    debugPrint('Error parsing password from Zoom URL: $fullZoomUrl - $e');
  }
  return null;
}

String parseZoomUrlToInternalString(String fullZoomUrl) {
  final zoomId = parseZoomIdFromUrl(fullZoomUrl); // Use the NEW parser for URLs
  final password =
      parsePasswordFromUrl(fullZoomUrl); // Use the NEW parser for URLs
  return buildInternalWebString(zoomId, password); // Build your internal format
}
