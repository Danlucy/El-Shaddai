import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:models/models.dart';
import 'package:util/util.dart';

part 'booking_state.freezed.dart';
part 'booking_state.g.dart';

@freezed
class BookingState with _$BookingState {
  const BookingState._();
  @CustomDateTimeRangeConverter()
  @LocationDataConverter()
  const factory BookingState({
    CustomDateTimeRange? timeRange,
    String? bookingId,
    String? hostId,
    String? title,
    String? description,
    LocationData? location,
    String? password,
    @Default(RecurrenceState.none) RecurrenceState recurrenceState,
    @Default(2) int recurrenceFrequency,
  }) = _BookingState;
  factory BookingState.fromJson(Map<String, dynamic> json) =>
      _$BookingStateFromJson(json);
}
