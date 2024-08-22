import 'package:el_shaddai/core/utility/date_time_range.dart';
import 'package:el_shaddai/core/utility/json_converters.dart';
import 'package:el_shaddai/models/location_data.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_state.freezed.dart';
part 'event_state.g.dart';

@freezed
class EventState with _$EventState {
  const EventState._();
  @DateTimeRangeConverter()
  @LocationDataConverter()
  const factory EventState({
    DateTimeRange? timeRange,
    String? eventId,
    String? hostId,
    String? title,
    String? description,
    LocationData? location,
    @Default(RecurrenceState.none) RecurrenceState recurrenceState,
  }) = _EventState;
  factory EventState.fromJson(Map<String, dynamic> json) =>
      _$EventStateFromJson(json);
}

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
