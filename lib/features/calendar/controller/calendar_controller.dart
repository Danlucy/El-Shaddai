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
  //
  // @override
  // Color getColor(int index) {
  //   BookingModel currentBooking = _getMeetingData(index);
  //   // Get all bookings for the same date
  //   List bookingsOnSameDate = appointments!.where((booking) {
  //     return booking.timeRange.start.year ==
  //             currentBooking.timeRange.start.year &&
  //         booking.timeRange.start.month ==
  //             currentBooking.timeRange.start.month &&
  //         booking.timeRange.start.day == currentBooking.timeRange.start.day;
  //   }).toList() as List<BookingModel>;
  //   print(bookingsOnSameDate);
  //   print(currentBooking);
  //   int totalBookedMinutes = bookingsOnSameDate.fold(0, (sum, booking) {
  //     BookingModel b = booking as BookingModel;
  //     return sum + booking.timeRange.duration.inMinutes;
  //   });
  //   print(totalBookedMinutes);
  //   // Calculate total booked duration for that day
  //
  //   if (totalBookedMinutes <= 1440) {
  //     return Colors.green;
  //   } else {
  //     return Colors.red;
  //   }
  // }

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
