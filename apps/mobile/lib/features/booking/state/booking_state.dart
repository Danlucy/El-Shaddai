import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/customs/custom_date_time_range.dart';
import '../../../core/utility/json_converters.dart';
import '../../../models/location_data.dart';

part 'booking_state.freezed.dart';
part 'booking_state.g.dart';

enum RecurrenceState {
  none,
  daily,
  weekly;

  static RecurrenceState? fromName(String name) {
    for (RecurrenceState enumVariant in RecurrenceState.values) {
      if (enumVariant.name == name) return enumVariant;
    }
    return null;
  }
}

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
    @Default(RecurrenceState.none) RecurrenceState recurrenceState,
    @Default(2) int recurrenceFrequency,
  }) = _BookingState;
  factory BookingState.fromJson(Map<String, dynamic> json) =>
      _$BookingStateFromJson(json);
}
