import 'package:el_shaddai/features/event/state/event_state.dart';
import 'package:el_shaddai/models/location_data.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:time_range_picker/time_range_picker.dart';

part 'event_controller.g.dart';

@riverpod
class EventController extends _$EventController {
  @override
  EventState build() {
    return EventState();
  }

  void setTitle(String title) => state = state.copyWith(title: title);
  void setDescription(String description) =>
      state = state.copyWith(description: description);
  void setLocation(LocationData location) =>
      state = state.copyWith(location: location);
  void setEventId(String eventId) => state = state.copyWith(eventId: eventId);
  void setHostId(String hostId) => state = state.copyWith(hostId: hostId);
  void setRecurrenceState(RecurrenceState recurrenceState) =>
      state = state.copyWith(recurrenceState: recurrenceState);
  void setDateRange(DateTimeRange timeRange) {
    final start = state.timeRange?.start;
    final end = state.timeRange?.end;
    state = state.copyWith(
      timeRange: DateTimeRange(
        start: DateTime(
          timeRange.start.year,
          timeRange.start.month,
          timeRange.start.day,
          start?.hour ?? 12,
        ),
        end: DateTime(
          timeRange.start.year,
          timeRange.start.month,
          timeRange.start.day,
          end?.hour ?? 12,
        ),
      ),
    );
  }

  void setTimeRange(TimeRange timeOfDay) {
    final start = state.timeRange?.start;
    final end = state.timeRange?.end;
    state = state.copyWith(
      timeRange: DateTimeRange(
        start: DateTime(
          start?.year ?? 2222,
          start?.month ?? 1,
          start?.day ?? 12,
          timeOfDay.startTime.hour,
        ),
        end: DateTime(
          end?.year ?? 2222,
          end?.month ?? 2,
          end?.day ?? 2,
          timeOfDay.endTime.hour,
        ),
      ),
    );
  }
}
