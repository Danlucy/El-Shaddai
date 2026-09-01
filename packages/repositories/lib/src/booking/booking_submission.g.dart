// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_submission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookingDTO _$BookingDTOFromJson(Map<String, dynamic> json) => _BookingDTO(
  requestId: json['requestId'] as String,
  organizationId: json['organizationId'] as String,
  isUpdating: json['isUpdating'] as bool,
  bookingId: json['bookingId'] as String?,
  timezoneOffsetMinutes: (json['timezoneOffsetMinutes'] as num).toInt(),
  title: json['title'] as String,
  recurrenceState: $enumDecode(
    _$RecurrenceStateEnumMap,
    json['recurrenceState'],
  ),
  host: json['host'] as String,
  timeRange: const EpochMillisecondsDateTimeRangeConverter().fromJson(
    json['timeRange'] as Map<String, dynamic>,
  ),
  location: const LocationDataConverter().fromJson(
    json['location'] as Map<String, dynamic>,
  ),
  description: json['description'] as String,
  password: json['password'] as String?,
  recurrence:
      json['recurrence'] == null
          ? null
          : RecurrenceConfigurationModel.fromJson(
            json['recurrence'] as Map<String, dynamic>,
          ),
  zoomOccurrences:
      (json['zoomOccurrences'] as List<dynamic>?)
          ?.map(
            (e) => BookingSubmissionZoomOccurrence.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
);

Map<String, dynamic> _$BookingDTOToJson(
  _BookingDTO instance,
) => <String, dynamic>{
  'requestId': instance.requestId,
  'organizationId': instance.organizationId,
  'isUpdating': instance.isUpdating,
  'bookingId': instance.bookingId,
  'timezoneOffsetMinutes': instance.timezoneOffsetMinutes,
  'title': instance.title,
  'recurrenceState': _$RecurrenceStateEnumMap[instance.recurrenceState]!,
  'host': instance.host,
  'timeRange': const EpochMillisecondsDateTimeRangeConverter().toJson(
    instance.timeRange,
  ),
  'location': const LocationDataConverter().toJson(instance.location),
  'description': instance.description,
  'password': instance.password,
  'recurrence': instance.recurrence?.toJson(),
  'zoomOccurrences': instance.zoomOccurrences?.map((e) => e.toJson()).toList(),
};

const _$RecurrenceStateEnumMap = {
  RecurrenceState.none: 'none',
  RecurrenceState.daily: 'daily',
  RecurrenceState.weekly: 'weekly',
};

_BookingSubmissionZoomOccurrence _$BookingSubmissionZoomOccurrenceFromJson(
  Map<String, dynamic> json,
) => _BookingSubmissionZoomOccurrence(
  occurrenceId: _nullableStringFromJson(json['occurrence_id']),
);

Map<String, dynamic> _$BookingSubmissionZoomOccurrenceToJson(
  _BookingSubmissionZoomOccurrence instance,
) => <String, dynamic>{'occurrence_id': instance.occurrenceId};
