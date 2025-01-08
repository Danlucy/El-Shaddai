import 'package:el_shaddai/core/customs/custom_date_time_range.dart';
import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/features/auth/widgets/loader.dart';
import 'package:el_shaddai/features/booking/repository/booking_repository.dart';
import 'package:el_shaddai/features/calendar/controller/calendar_controller.dart';
import 'package:el_shaddai/features/calendar/widget/booking_details_dialog.dart';
import 'package:el_shaddai/models/booking_model/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DailyCalendarComponent extends ConsumerStatefulWidget {
  const DailyCalendarComponent({
    required this.dailyCalendarController,
    super.key,
  });
  final CalendarController dailyCalendarController;
  @override
  ConsumerState<DailyCalendarComponent> createState() =>
      _DailyCalendarComponentState();
}

class _DailyCalendarComponentState
    extends ConsumerState<DailyCalendarComponent> {
  @override
  Widget build(BuildContext context) {
    final bookingStream = ref.watch(bookingsProvider);
    ref.listen(
      calendarDateNotifierProvider,
      (previous, next) {
        widget.dailyCalendarController.displayDate = next;
      },
    );
    return bookingStream.when(
        data: (data) {
          return SfCalendar(
            appointmentBuilder:
                (BuildContext context, CalendarAppointmentDetails details) {
              // Extract the BookingModel from the appointment details
              BookingModel bookingModel = details.appointments.first;

              return GestureDetector(
                onTap: () {
                  // Show dialog with the correct bookingModel
                  showDialog(
                    context: context,
                    builder: (context) {
                      return BookingDetailsDialog(
                        bookingModel:
                            bookingModel, // Pass the correct BookingModel
                      );
                    },
                  );
                },
                child: Container(
                  color: context.colors.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bookingModel.title,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: context.colors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            dataSource: _getCalendarDataSource(data),
            controller: widget.dailyCalendarController,
            view: CalendarView.day,
            timeSlotViewSettings: const TimeSlotViewSettings(
                timeRulerSize: 80,
                timeIntervalHeight: 80,
                timeFormat: 'hh:mm a',
                timeInterval: Duration(
                  minutes: 30,
                )),
          );
        },
        error: (error, stack) {
          return const Center(
            child: Text('Error'),
          );
        },
        loading: () => const Loader());
  }
}

_AppointmentDataSource _getCalendarDataSource(List<BookingModel> bookingModel) {
  List<BookingModel> appointments = <BookingModel>[];
  for (BookingModel booking in bookingModel) {
    int duration = booking.timeRange.end.day - booking.timeRange.start.day;
    for (int i = 0; i < duration + 1; i++) {
      DateTime appointmentDate = booking.timeRange.start.add(Duration(days: i));

      // For the first day, set the start time to the original start time
      DateTime currentStartTime = (i == 0)
          ? booking.timeRange.start
          : DateTime(appointmentDate.year, appointmentDate.month,
              appointmentDate.day, 0, 0);

      // For the last day, set the end time to the original end time
      DateTime currentEndTime = (i == duration)
          ? booking.timeRange.end
          : DateTime(appointmentDate.year, appointmentDate.month,
              appointmentDate.day, 23, 59);

      appointments.add(BookingModel(
          timeRange:
              CustomDateTimeRange(start: currentStartTime, end: currentEndTime),
          description: booking.description,
          title: booking.title,
          recurrenceState: booking.recurrenceState,
          location: booking.location,
          createdAt: booking.createdAt,
          host: booking.host,
          userId: booking.userId,
          id: booking.id));
    }
  }

  return _AppointmentDataSource(appointments);
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
