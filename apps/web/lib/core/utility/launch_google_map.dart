import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenLocationURL {
  final LatLng coords;
  final String? label;
  final String? locationName;

  const OpenLocationURL({required this.coords, this.label, this.locationName});
  OpenLocationURL.fromLatLng({
    required double latitude,
    required double longitude,
    this.label,
    this.locationName,
  }) : coords = LatLng(latitude, longitude);
  Future<void> openGoogleMaps({
    bool newTab = true,
    bool showDirections = true,
  }) async {
    final String googleMapsUrl = showDirections
        ? _buildGoogleDirectionsUrl(coords.latitude, coords.longitude)
        : _buildGoogleMapsUrl(
            latitude: coords.latitude,
            longitude: coords.longitude,
            label: label,
          );

    await _launchURL(googleMapsUrl, newTab);
  }

  /// Opens the location in Waze for navigation
  ///
  /// [navigate] - If true, starts navigation immediately (default: true)
  Future<void> openWaze({bool navigate = true}) async {
    final String wazeUrl = _buildWazeUrl(
      latitude: coords.latitude,
      longitude: coords.longitude,
      navigate: navigate,
    );

    await _launchURL(wazeUrl, true);
  }

  Future<void> _launchURL(String url, bool newTab) async {
    try {
      final Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        LaunchMode mode = kIsWeb && newTab
            ? LaunchMode.externalApplication
            : LaunchMode.externalApplication;

        await launchUrl(uri, mode: mode);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error launching URL: $url - $e');
      }
      rethrow;
    }
  }

  /// Builds Google Maps URL for viewing location
  String _buildGoogleMapsUrl({
    required double latitude,
    required double longitude,
    String? label,
    int zoom = 15,
  }) {
    final String coords = '$latitude,$longitude';

    if (label != null && label.isNotEmpty) {
      // With custom label - better URL format
      final encodedLabel = Uri.encodeComponent(label);
      return 'https://www.google.com/maps/search/?api=1&query=$coords($encodedLabel)';
    } else {
      // Just coordinates
      return 'https://www.google.com/maps/@$latitude,$longitude,${zoom}z';
    }
  }

  /// Builds Google Maps URL for directions
  String _buildGoogleDirectionsUrl(double latitude, double longitude) {
    return 'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
  }

  /// Builds Waze URL
  String _buildWazeUrl({
    required double latitude,
    required double longitude,
    bool navigate = true,
  }) {
    if (navigate) {
      // Direct navigation
      return 'https://waze.com/ul?ll=$latitude%2C$longitude&navigate=yes';
    } else {
      // Just show location
      return 'https://waze.com/ul?ll=$latitude%2C$longitude';
    }
  }

  /// Builds Apple Maps URL for viewing location
}

extension LatLngExtension on LatLng {
  /// Creates an OpenLocationURL instance for this coordinate
  OpenLocationURL toLocationURL({String? label, String? locationName}) {
    return OpenLocationURL(
      coords: this,
      label: label,
      locationName: locationName,
    );
  }

  /// Quick method to open this coordinate in Google Maps
  Future<void> openInGoogleMaps({String? label}) async {
    final launcher = OpenLocationURL(coords: this, label: label);
    await launcher.openGoogleMaps();
  }

  /// Quick method to open this coordinate in Waze
  Future<void> openInWaze() async {
    final launcher = OpenLocationURL(coords: this);
    await launcher.openWaze();
  }

  /// Quick method to show map options dialog
}
