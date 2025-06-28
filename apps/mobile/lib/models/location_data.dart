import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../core/utility/json_converters.dart';

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

  String meetingID({bool? spaced}) {
    if (web == null) throw 'No link';
    RegExp regExp = RegExp(r'\/j\/(\d+)');
    Match? match = regExp.firstMatch(web!);
    if (spaced == true) {
      return match != null
          ? match
              .group(1)!
              .replaceAllMapped(RegExp(r'(\d{4})'), (Match m) => '${m[1]} ')
              .trim()
          : ''
              .replaceAllMapped(RegExp(r'(\d{4})'), (Match m) => '${m[1]} ')
              .trim();
    } else {
      return match != null ? match.group(1)! : '';
    }
  }
}
