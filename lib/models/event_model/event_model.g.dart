// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventModelImpl _$$EventModelImplFromJson(Map<String, dynamic> json) =>
    _$EventModelImpl(
      title: json['title'] as String,
      hostId: json['hostId'] as String,
      timeRange: const DateTimeRangeConverter()
          .fromJson(json['timeRange'] as Map<String, dynamic>),
      userId: json['userId'] as String,
      id: json['id'] as String,
      location: const LocationDataConverter()
          .fromJson(json['location'] as Map<String, dynamic>),
      description: json['description'] as String,
    );

Map<String, dynamic> _$$EventModelImplToJson(_$EventModelImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'hostId': instance.hostId,
      'timeRange': const DateTimeRangeConverter().toJson(instance.timeRange),
      'userId': instance.userId,
      'id': instance.id,
      'location': const LocationDataConverter().toJson(instance.location),
      'description': instance.description,
    };
