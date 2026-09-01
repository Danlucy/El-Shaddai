// ignore_for_file: invalid_annotation_target

import 'package:api/api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:models/models.dart';
import 'package:util/util.dart';

part 'booking_submission.freezed.dart';
part 'booking_submission.g.dart';

@freezed
sealed class BookingDTO with _$BookingDTO {
  const BookingDTO._();

  @JsonSerializable(explicitToJson: true)
  const factory BookingDTO({
    required String requestId,
    required String organizationId,
    required bool isUpdating,
    required String? bookingId,
    required int timezoneOffsetMinutes,
    required String title,
    required RecurrenceState recurrenceState,
    required String host,
    @EpochMillisecondsDateTimeRangeConverter()
    required CustomDateTimeRange timeRange,
    @LocationDataConverter() required LocationData location,
    required String description,
    required String? password,
    required RecurrenceConfigurationModel? recurrence,
    required List<BookingSubmissionZoomOccurrence>? zoomOccurrences,
  }) = _BookingDTO;

  factory BookingDTO.fromJson(Map<String, dynamic> json) =>
      _$BookingDTOFromJson(json);

  Map<String, dynamic> toCallableData() => toJson();
}

@freezed
sealed class BookingSubmissionZoomOccurrence
    with _$BookingSubmissionZoomOccurrence {
  const BookingSubmissionZoomOccurrence._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory BookingSubmissionZoomOccurrence({
    @JsonKey(fromJson: _nullableStringFromJson) required String? occurrenceId,
  }) = _BookingSubmissionZoomOccurrence;

  factory BookingSubmissionZoomOccurrence.fromJson(Map<String, dynamic> json) =>
      _$BookingSubmissionZoomOccurrenceFromJson(json);

  factory BookingSubmissionZoomOccurrence.fromZoomResponse(dynamic occurrence) {
    if (occurrence is Map) {
      return BookingSubmissionZoomOccurrence.fromJson(
        occurrence.map((key, value) => MapEntry(key.toString(), value)),
      );
    }

    return BookingSubmissionZoomOccurrence(occurrenceId: occurrence.toString());
  }
}

String? _nullableStringFromJson(Object? value) => value?.toString();
