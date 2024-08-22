// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingModelImpl _$$BookingModelImplFromJson(Map<String, dynamic> json) =>
    _$BookingModelImpl(
      userId: json['userId'] as String,
      eventId: json['eventId'] as String,
      timeRange: const DateTimeRangeConverter()
          .fromJson(json['timeRange'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$BookingModelImplToJson(_$BookingModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'eventId': instance.eventId,
      'timeRange': const DateTimeRangeConverter().toJson(instance.timeRange),
    };
