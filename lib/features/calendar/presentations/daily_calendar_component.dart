import 'package:el_shaddai/core/customs/custom_date_time_range.dart';
import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/core/utility/url_launcher.dart';
import 'package:el_shaddai/core/widgets/calendar_widget.dart';
import 'package:el_shaddai/features/auth/widgets/loader.dart';
import 'package:el_shaddai/features/booking/repository/booking_repository.dart';
import 'package:el_shaddai/features/calendar/controller/calendar_controller.dart';
import 'package:el_shaddai/models/booking_model/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final bookingStream = ref.watch(bookingsProvider);
    ref.listen(
      calendarDateNotifierProvider,
      (previous, next) {
        widget.dailyCalendarController.displayDate = next;
      },
    );
    return Expanded(
        child: bookingStream.when(
            data: (data) {
              return SfCalendar(
                appointmentBuilder:
                    (BuildContext context, CalendarAppointmentDetails details) {
                  BookingModel bookingModel = details.appointments.first;
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return BookingDetailsDialog(
                              width: width,
                              height: height,
                              bookingModel: bookingModel);
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
                              bookingModel.host,
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
                onTap: (details) {
                  print(details.date);
                },
                timeSlotViewSettings: const TimeSlotViewSettings(
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
            loading: () => const Loader()));
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
          appointmentTimeRange: CustomDateTimeRange(
              start: booking.timeRange.start, end: booking.timeRange.end),
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
        timeRange: customData.appointmentTimeRange,
        appointmentTimeRange: customData.timeRange,
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

class BookingDetailsDialog extends StatelessWidget {
  const BookingDetailsDialog({
    super.key,
    required this.width,
    required this.height,
    required this.bookingModel,
  });

  final double width;
  final double height;
  final BookingModel bookingModel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      content: Container(
        padding: EdgeInsets.zero,
        width: width * 0.8,
        height: height * 0.85,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            bookingModel.title,
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.inverseSurface),
          ),
          Text(
            bookingModel.host,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.outline),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                CalenderWidget(
                    date: bookingModel.appointmentTimeRange.start,
                    color: Theme.of(context).colorScheme.primary),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(DateFormat.jm()
                      .format(bookingModel.appointmentTimeRange.start)),
                ),
                const Icon(Icons.arrow_right_alt_outlined),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(DateFormat.jm()
                      .format(bookingModel.appointmentTimeRange.end)),
                ),
                CalenderWidget(
                    date: bookingModel.appointmentTimeRange.end,
                    color: Theme.of(context).colorScheme.primary),
              ],
            ),
          ),
          if (bookingModel.location.web != null)
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    launchURL(bookingModel.location.web!);
                  },
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    radius: 20,
                    backgroundImage: const AssetImage('assets/zoom.png'),
                  ),
                ),
                const Gap(5),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: bookingModel.location.meetingID()));
                  },
                  child: Text(
                    bookingModel.location.meetingID(spaced: true),
                  ),
                ),
              ],
            ),
          const Gap(5),
          Container(
            decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.onSecondary.withOpacity(0.4),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
            child: Text(
              bookingModel.description,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        ]),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
    );
  }
}
