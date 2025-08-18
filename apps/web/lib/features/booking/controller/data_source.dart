// Data source for the SfCalendar
import 'package:models/models.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

_AppointmentDataSource getCalendarDataSource(List<BookingModel> bookingModel) {
  return _AppointmentDataSource(bookingModel);
}

class _AppointmentDataSource extends CalendarDataSource<BookingModel> {
  _AppointmentDataSource(List<BookingModel> source) {
    appointments = source;
  }
  @override
  DateTime getStartTime(int index) {
    return appointments![index].timeRange.start as DateTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].timeRange.end as DateTime;
  }

  @override
  String getTitle(int index) {
    return appointments?[index].title as String;
  }

  @override
  BookingModel convertAppointmentToObject(
      BookingModel customData, Appointment appointment) {
    return customData;
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

class AppointmentDataSource extends CalendarDataSource<BookingModel> {
  AppointmentDataSource(List<BookingModel> source) {
    appointments = source;
  }
  @override
  DateTime getStartTime(int index) {
    return appointments![index].timeRange.start as DateTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].timeRange.end as DateTime;
  }

  @override
  String getDescription(int index) {
    return appointments![index].description as String;
  }

  @override
  String getTitle(int index) {
    return appointments?[index].title as String;
  }

  @override
  BookingModel convertAppointmentToObject(
      BookingModel customData, Appointment appointment) {
    return BookingModel(
        timeRange: customData.timeRange,
        description: customData.description,
        title: customData.title,
        recurrenceState: customData.recurrenceState,
        location: customData.location,
        createdAt: customData.createdAt,
        host: customData.host,
        userId: customData.userId,
        id: customData.id);
  }
}
