import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_shaddai/api/models/recurrence_configuration_model/recurrence_configuration_model.dart';
import 'package:el_shaddai/models/location_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

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
