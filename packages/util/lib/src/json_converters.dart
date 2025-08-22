import 'package:api/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

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

//
// class RecurrenceConfigurationModelConverter extends JsonConverter<RecurrenceConfigurationModel, Map<String, dynamic>> {
//   const RecurrenceConfigurationModelConverter();
//   @override
//   RecurrenceConfigurationModel fromJson(Map<String, dynamic> json) {
//     return RecurrenceConfiguration(
//       recurrenceState: RecurrenceState.values[json['recurrenceState'] as int],
//       recurrenceFrequency: json['recurrenceFrequency'] as int,
//     );
//   }
//
//   @override
//   Map<String, dynamic> toJson(RecurrenceConfigurationModel object) {
//     return {
//       'recurrenceState': object.,
//       'recurrenceFrequency': object.recurrenceFrequency,
//     };
//   }
// }
class RecurrenceConfigurationConverter
    implements
        JsonConverter<RecurrenceConfigurationModel, Map<String, dynamic>> {
  const RecurrenceConfigurationConverter();

  @override
  RecurrenceConfigurationModel fromJson(Map<String, dynamic> json) {
    return RecurrenceConfigurationModel.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(RecurrenceConfigurationModel data) {
    return data.toJson();
  }
}

class LocationDataConverter
    extends JsonConverter<LocationData, Map<String, dynamic>> {
  const LocationDataConverter();
  @override
  LocationData fromJson(Map json) {
    return LocationData(
      web: json['web'] as String?,
      address: json['address'] as String?,
      chords: json['chords'] != null
          ? LatLng(
              json['chords']['latitude'] as double,
              json['chords']['longitude'] as double,
            )
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson(LocationData object) {
    return {
      'address': object.address,
      'chords': object.chords != null
          ? {
              'latitude': object.chords!.latitude,
              'longitude': object.chords!.longitude,
            }
          : null,
      'web': object.web,
    };
  }
}
class TimestampConverter implements JsonConverter<DateTime, Object?> {
  const TimestampConverter();

  @override
  DateTime fromJson(Object? json) {
    if (json is Timestamp) return json.toDate();
    if (json is String) return DateTime.parse(json);
    throw ArgumentError('Invalid date format: $json');
  }

  @override
  Object toJson(DateTime object) => object;
}
