import 'package:el_shaddai/core/utility/json_converters.dart';
import 'package:latlong2/latlong.dart';

@LatLngConverter()
class LocationData {
  final LatLng? chords;
  final String? web;
  final String address;

  LocationData({this.chords, required this.address, this.web});
}
