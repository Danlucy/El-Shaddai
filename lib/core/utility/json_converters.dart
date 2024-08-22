import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_shaddai/models/location_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';

class LatLngConverter extends JsonConverter<LatLng?, Object?> {
  const LatLngConverter();
  @override
  LatLng? fromJson(Object? json) {
    if (json is GeoPoint) {
      return LatLng(
        json.latitude,
        json.longitude,
      );
    }
    if (json is Map &&
        json.containsKey('latitude') &&
        json.containsKey('longitude')) {
      return LatLng(
        json['latitude'],
        json['longitude'],
      );
    }
    return null;
  }

  @override
  GeoPoint? toJson(LatLng? object) {
    if (object == null) return null;
    return GeoPoint(object.latitude, object.longitude);
  }

  GeoPoint toFirestore(LatLng object) {
    return GeoPoint(object.latitude, object.longitude);
  }
}

class LocationDataConverter
    extends JsonConverter<LocationData, Map<String, dynamic>> {
  const LocationDataConverter();
  @override
  LocationData fromJson(Map json) {
    return LocationData(
      web: json['web'] as String?,
      address: json['address'] as String,
      chords: json['location'] != null
          ? LatLng(
              json['location']['latitude'] as double,
              json['location']['longitude'] as double,
            )
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson(LocationData object) {
    return {
      'address': object.address,
      'chords': object.chords,
      'web': object.web,
    };
  }
}
