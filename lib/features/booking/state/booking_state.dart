import 'package:el_shaddai/core/utility/date_time_range.dart';
import 'package:el_shaddai/core/utility/json_converters.dart';
import 'package:el_shaddai/models/location_data.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
  @DateTimeRangeConverter()
  @LocationDataConverter()
  const factory BookingState({
    DateTimeRange? timeRange,
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
