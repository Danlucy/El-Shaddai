// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingStateImpl _$$BookingStateImplFromJson(Map<String, dynamic> json) =>
    _$BookingStateImpl(
      userId: json['userId'] as String,
      eventId: json['eventId'] as String,
      timeRange: const DateTimeRangeConverter()
          .fromJson(json['timeRange'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$BookingStateImplToJson(_$BookingStateImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'eventId': instance.eventId,
      'timeRange': const DateTimeRangeConverter().toJson(instance.timeRange),
    };
