// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zoom_meeting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ZoomMeetingModelImpl _$$ZoomMeetingModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ZoomMeetingModelImpl(
      topic: json['topic'] as String?,
      description: json['agenda'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      password: json['password'] as String?,
      recurrenceConfiguration: _$JsonConverterFromJson<Map<String, dynamic>,
              RecurrenceConfigurationModel>(json['recurrence'],
          const RecurrenceConfigurationConverter().fromJson),
      startTime: DateTime.parse(json['start_time'] as String),
      type: (json['type'] as num?)?.toInt() ?? 2,
      defaultPassword: json['default_password'] as bool? ?? false,
    );

Map<String, dynamic> _$$ZoomMeetingModelImplToJson(
        _$ZoomMeetingModelImpl instance) =>
    <String, dynamic>{
      'topic': instance.topic,
      'agenda': instance.description,
      'duration': instance.duration,
      'password': instance.password,
      'recurrence': _$JsonConverterToJson<Map<String, dynamic>,
              RecurrenceConfigurationModel>(instance.recurrenceConfiguration,
          const RecurrenceConfigurationConverter().toJson),
      'start_time': instance.startTime.toIso8601String(),
      'type': instance.type,
      'default_password': instance.defaultPassword,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
