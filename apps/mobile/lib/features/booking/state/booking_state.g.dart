// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingStateImpl _$$BookingStateImplFromJson(Map<String, dynamic> json) =>
    _$BookingStateImpl(
      timeRange:
          _$JsonConverterFromJson<Map<String, dynamic>, CustomDateTimeRange>(
              json['timeRange'], const CustomDateTimeRangeConverter().fromJson),
      bookingId: json['bookingId'] as String?,
      hostId: json['hostId'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      location: _$JsonConverterFromJson<Map<String, dynamic>, LocationData>(
          json['location'], const LocationDataConverter().fromJson),
      password: json['password'] as String?,
      recurrenceState: $enumDecodeNullable(
              _$RecurrenceStateEnumMap, json['recurrenceState']) ??
          RecurrenceState.none,
      recurrenceFrequency: (json['recurrenceFrequency'] as num?)?.toInt() ?? 2,
    );

Map<String, dynamic> _$$BookingStateImplToJson(_$BookingStateImpl instance) =>
    <String, dynamic>{
      'timeRange':
          _$JsonConverterToJson<Map<String, dynamic>, CustomDateTimeRange>(
              instance.timeRange, const CustomDateTimeRangeConverter().toJson),
      'bookingId': instance.bookingId,
      'hostId': instance.hostId,
      'title': instance.title,
      'description': instance.description,
      'location': _$JsonConverterToJson<Map<String, dynamic>, LocationData>(
          instance.location, const LocationDataConverter().toJson),
      'password': instance.password,
      'recurrenceState': _$RecurrenceStateEnumMap[instance.recurrenceState]!,
      'recurrenceFrequency': instance.recurrenceFrequency,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

const _$RecurrenceStateEnumMap = {
  RecurrenceState.none: 'none',
  RecurrenceState.daily: 'daily',
  RecurrenceState.weekly: 'weekly',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
