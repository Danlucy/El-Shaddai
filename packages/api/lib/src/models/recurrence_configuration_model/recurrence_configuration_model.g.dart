// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurrence_configuration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecurrenceConfigurationModel _$RecurrenceConfigurationModelFromJson(
  Map<String, dynamic> json,
) => _RecurrenceConfigurationModel(
  recurrenceFrequency: (json['end_times'] as num).toInt(),
  weeklyDays: (json['weekly_days'] as num?)?.toInt(),
  type: (json['type'] as num).toInt(),
  recurrenceInterval: (json['repeat_interval'] as num).toInt(),
);

Map<String, dynamic> _$RecurrenceConfigurationModelToJson(
  _RecurrenceConfigurationModel instance,
) => <String, dynamic>{
  'end_times': instance.recurrenceFrequency,
  'weekly_days': instance.weeklyDays,
  'type': instance.type,
  'repeat_interval': instance.recurrenceInterval,
};
