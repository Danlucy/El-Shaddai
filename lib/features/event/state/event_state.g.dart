// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventStateImpl _$$EventStateImplFromJson(Map<String, dynamic> json) =>
    _$EventStateImpl(
      timeRange: _$JsonConverterFromJson<Map<String, dynamic>, DateTimeRange>(
          json['timeRange'], const DateTimeRangeConverter().fromJson),
      eventId: json['eventId'] as String?,
      hostId: json['hostId'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      location: _$JsonConverterFromJson<Map<String, dynamic>, LocationData>(
          json['location'], const LocationDataConverter().fromJson),
      recurrenceState: $enumDecodeNullable(
              _$RecurrenceStateEnumMap, json['recurrenceState']) ??
          RecurrenceState.none,
    );

Map<String, dynamic> _$$EventStateImplToJson(_$EventStateImpl instance) =>
    <String, dynamic>{
      'timeRange': _$JsonConverterToJson<Map<String, dynamic>, DateTimeRange>(
          instance.timeRange, const DateTimeRangeConverter().toJson),
      'eventId': instance.eventId,
      'hostId': instance.hostId,
      'title': instance.title,
      'description': instance.description,
      'location': _$JsonConverterToJson<Map<String, dynamic>, LocationData>(
          instance.location, const LocationDataConverter().toJson),
      'recurrenceState': _$RecurrenceStateEnumMap[instance.recurrenceState]!,
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
