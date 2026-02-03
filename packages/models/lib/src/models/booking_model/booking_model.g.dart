// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookingModel _$BookingModelFromJson(Map<String, dynamic> json) =>
    _BookingModel(
      title: json['title'] as String,
      recurrenceState: $enumDecode(
        _$RecurrenceStateEnumMap,
        json['recurrenceState'],
      ),
      host: json['host'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      timeRange: const CustomDateTimeRangeConverter().fromJson(
        json['timeRange'] as Map<String, dynamic>,
      ),
      userId: json['userId'] as String,
      id: json['id'] as String,
      location: const LocationDataConverter().fromJson(
        json['location'] as Map<String, dynamic>,
      ),
      description: json['description'] as String,
      password: json['password'] as String?,
      recurrenceModel: _$JsonConverterFromJson<
        Map<String, dynamic>,
        RecurrenceConfigurationModel
      >(
        json['recurrenceModel'],
        const RecurrenceConfigurationConverter().fromJson,
      ),
      occurrenceId: json['occurrenceId'] as String?,
      groupId: json['groupId'] as String?,
    );

Map<String, dynamic> _$BookingModelToJson(
  _BookingModel instance,
) => <String, dynamic>{
  'title': instance.title,
  'recurrenceState': _$RecurrenceStateEnumMap[instance.recurrenceState]!,
  'host': instance.host,
  'createdAt': instance.createdAt.toIso8601String(),
  'timeRange': const CustomDateTimeRangeConverter().toJson(instance.timeRange),
  'userId': instance.userId,
  'id': instance.id,
  'location': const LocationDataConverter().toJson(instance.location),
  'description': instance.description,
  'password': instance.password,
  'recurrenceModel':
      _$JsonConverterToJson<Map<String, dynamic>, RecurrenceConfigurationModel>(
        instance.recurrenceModel,
        const RecurrenceConfigurationConverter().toJson,
      ),
  'occurrenceId': instance.occurrenceId,
  'groupId': instance.groupId,
};

const _$RecurrenceStateEnumMap = {
  RecurrenceState.none: 'none',
  RecurrenceState.daily: 'daily',
  RecurrenceState.weekly: 'weekly',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
