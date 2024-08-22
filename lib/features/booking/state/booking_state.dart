import 'package:el_shaddai/core/utility/date_time_range.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_state.g.dart';
part 'booking_state.freezed.dart';

@freezed
class BookingState with _$BookingState {
  const BookingState._();
  const factory BookingState({
    required String userId,
    required String eventId,
    @DateTimeRangeConverter() required DateTimeRange timeRange,
  }) = _BookingState;

  factory BookingState.fromJson(Map<String, dynamic> json) =>
      _$BookingStateFromJson(json);
}
