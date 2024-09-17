import 'package:el_shaddai/core/utility/json_converters.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@LatLngConverter()
class LocationData {
  final LatLng? chords;
  final String? web;
  final String? address;

  LocationData({this.chords, required this.address, this.web});

  LocationData copyWith({
    LatLng? chords,
    String? web,
    String? address,
  }) {
    return LocationData(
      chords: chords ?? this.chords,
      address: address ?? this.address,
      web: web ?? this.web,
    );
  }
}
