import 'package:collection/collection.dart';
import 'package:el_shaddai/features/booking/state/booking_state.dart';
import 'package:el_shaddai/models/booking_model/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

part 'calendar_controller.g.dart';

@riverpod
class CalendarDateNotifier extends _$CalendarDateNotifier {
  @override
  DateTime build() {
    return DateTime.now(); // Initial state
  }

  void updateSelectedDate(DateTime date) {
    state = date; // Update the state with the selected date
  }
}

class BookingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  BookingDataSource(List<BookingModel> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).timeRange.start;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).timeRange.end;
  }

  @override
  String getDescription(int index) {
    return _getMeetingData(index).description;
  }

  BookingModel getAppointments(int index) =>
      appointments![index] as BookingModel;
  BookingModel _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final BookingModel meetingData;
    if (meeting is BookingModel) {
      meetingData = meeting;
    }

    return meetingData;
  }
}
