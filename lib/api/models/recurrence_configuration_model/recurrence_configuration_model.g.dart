// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurrence_configuration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecurrenceConfigurationModel _$RecurrenceConfigurationModelFromJson(
        Map<String, dynamic> json) =>
    RecurrenceConfigurationModel(
      recurrenceFrequency: (json['end_times'] as num).toInt(),
      weeklyDays: (json['weekly_days'] as num?)?.toInt(),
      type: (json['type'] as num).toInt(),
      recurrenceInterval: (json['repeat_interval'] as num).toInt(),
    );

Map<String, dynamic> _$RecurrenceConfigurationModelToJson(
        RecurrenceConfigurationModel instance) =>
    <String, dynamic>{
      'end_times': instance.recurrenceFrequency,
      'weekly_days': instance.weeklyDays,
      'type': instance.type,
      'repeat_interval': instance.recurrenceInterval,
    };

Map<String, dynamic> _$$RecurrenceConfigurationModelImplToJson(
        _$RecurrenceConfigurationModelImpl instance) =>
    <String, dynamic>{
      'end_times': instance.recurrenceFrequency,
      'weeklyDays': instance.weeklyDays,
      'type': instance.type,
      'repeat_interval': instance.recurrenceInterval,
    };
