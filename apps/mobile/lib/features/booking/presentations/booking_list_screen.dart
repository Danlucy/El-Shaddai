import 'dart:async'; // Import the dart:async library for the Timer

import 'package:auto_size_text/auto_size_text.dart';
import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:util/util.dart';

import '../../../core/widgets/loader.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/widgets/confirm_button.dart';
import '../../calendar/widget/booking_details_dialog.dart';
import '../../home/widgets/general_drawer.dart';
import 'booking_screen.dart';

class BookingListScreen extends ConsumerStatefulWidget {
  const BookingListScreen({super.key});

  @override
  ConsumerState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends ConsumerState<BookingListScreen> {
  // Two timers to handle the synchronized refresh
  Timer? _initialTimer;
  Timer? _periodicTimer;

  // A simple counter to force a rebuild

  @override
  void initState() {
    super.initState();
    // Calculate the delay until the start of the next minute
    final now = DateTime.now();
    final delay = Duration(
      seconds: 60 - now.second,
      milliseconds: 1000 - now.millisecond,
    );

    // Start a one-time timer with the calculated delay
    _initialTimer = Timer(delay, () {
      if (mounted) {
        // Trigger the first rebuild immediately
        setState(() {});
        // Now, start the periodic timer for every subsequent minute
        _periodicTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
          if (mounted) {
            setState(() {});
          }
        });
      }
    });
  }

  @override
  void dispose() {
    // IMPORTANT: Cancel both timers when the widget is disposed
    _initialTimer?.cancel();
    _periodicTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final textScaleFactor = TextScaleFactor.scaleFactor(textScale);
    final today = DateTime.now();

    final user = ref.read(userProvider);
    // Determine flex proportions based on TextScaleFactor
    double appointmentHeight = 70; // Default: Equal space

    if (textScaleFactor == TextScaleFactor.oldMan) {
      appointmentHeight = 110; // DailyCalendarComponent takes 30%
    } else if (textScaleFactor == TextScaleFactor.boomer) {
      appointmentHeight = 90; // DailyCalendarComponent takes 30%
    }
    final bookingStream = ref.watch(bookingStreamProvider());
    return Scaffold(
      drawer: const GeneralDrawer(),
      appBar: AppBar(title: const Text('Prayer Watch List')),
      body: bookingStream.when(
        data: (data) {
          return SfCalendar(
            showNavigationArrow: true,
            view: CalendarView.schedule,
            scheduleViewSettings: ScheduleViewSettings(
              dayHeaderSettings: const DayHeaderSettings(width: 60),
              appointmentItemHeight: appointmentHeight,
              monthHeaderSettings: const MonthHeaderSettings(height: 80),
              hideEmptyScheduleWeek: true,
            ),
            showDatePickerButton: true,
            appointmentBuilder:
                (BuildContext context, CalendarAppointmentDetails details) {
                  BookingModel bookingModel = details.appointments.first;

                  // Get the appointment's date from the details
                  final appointmentDate = details.date;
                  final currentTime = DateTime.now();

                  // Check if the appointment is within 10 minutes of starting
                  final isUpcomingAppointment =
                      currentTime.isAfter(
                        bookingModel.timeRange.start.subtract(
                          const Duration(minutes: 10),
                        ),
                      ) &&
                      currentTime.isBefore(bookingModel.timeRange.start);

                  // Check if the appointment is currently live
                  final isLiveAppointment =
                      currentTime.isAfter(bookingModel.timeRange.start) &&
                      currentTime.isBefore(bookingModel.timeRange.end);

                  // Check if the appointment date is before today
                  final isPastAppointment = appointmentDate.isBefore(
                    DateTime(today.year, today.month, today.day),
                  );

                  // Choose the color based on the state. The order is important.
                  final appointmentColor = isLiveAppointment
                      ? context.colors.errorContainer.withOpac(0.4)
                      // Live appointments are red
                      : isUpcomingAppointment
                      ? context
                            .colors
                            .tertiary // Upcoming appointments get a new color
                      : isPastAppointment
                      ? Theme.of(context).colorScheme.secondaryContainer
                            .withOpac(0.5) // Muted for past dates
                      : Theme.of(
                          context,
                        ).colorScheme.secondaryContainer; // Default color

                  return GestureDetector(
                    onLongPress: () {
                      if (bookingModel.userId != user.value?.uid &&
                          user.value?.role != UserRole.admin) {
                        return;
                      }
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ConfirmButton(
                            confirmText: 'Delete ',
                            cancelText: 'Cancel',
                            description:
                                'Are you sure you want to delete this booking? This action cannot be reversed',
                            confirmAction: () {
                              context.pop();

                              ref
                                  .read(bookingRepositoryProvider)
                                  .deleteBooking(bookingModel.id);
                            },
                          );
                        },
                      );
                    },
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return BookingDetailsDialog(
                            bookingModel: bookingModel,
                          );
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: appointmentColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              maxLines: 1,
                              maxFontSize: 16,
                              minFontSize: 12,
                              overflow: TextOverflow.ellipsis,
                              bookingModel.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            AutoSizeText(
                              bookingModel.host,
                              maxFontSize: 12,
                              minFontSize: 8,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Row(
                              children: [
                                AutoSizeText(
                                  maxFontSize: 14,
                                  minFontSize: 10,
                                  DateFormat(
                                    'hh:mm a',
                                  ).format(bookingModel.timeRange.start),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const Icon(Icons.arrow_right_alt),
                                AutoSizeText(
                                  maxFontSize: 14,
                                  minFontSize: 10,
                                  DateFormat(
                                    'hh:mm a',
                                  ).format(bookingModel.timeRange.end),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
            dataSource: _getCalendarDataSource(data),
            scheduleViewMonthHeaderBuilder:
                (
                  BuildContext buildContext,
                  ScheduleViewMonthHeaderDetails details,
                ) {
                  return Container(
                    color: Theme.of(context).colorScheme.onPrimary,
                    child: Center(
                      child: AutoSizeText(
                        maxFontSize: 24,
                        minFontSize: 16,
                        DateFormat('MMMM yyyy').format(details.date),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inverseSurface,
                        ),
                      ),
                    ),
                  );
                },
          );
        },
        error: (error, stack) {
          return const Center(child: Text('Error'));
        },
        loading: () => const Loader(),
      ),
    );
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
          : DateTime(
              appointmentDate.year,
              appointmentDate.month,
              appointmentDate.day,
              0,
              0,
            );

      // For the last day, set the end time to the original end time
      DateTime currentEndTime = (i == duration)
          ? booking.timeRange.end
          : DateTime(
              appointmentDate.year,
              appointmentDate.month,
              appointmentDate.day,
              23,
              59,
            );

      appointments.add(
        BookingModel(
          timeRange: CustomDateTimeRange(
            start: currentStartTime,
            end: currentEndTime,
          ),
          description: booking.description,
          title: booking.title,
          recurrenceState: booking.recurrenceState,
          location: booking.location,
          createdAt: booking.createdAt,
          host: booking.host,
          userId: booking.userId,
          id: booking.id,
        ),
      );
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
    BookingModel customData,
    Appointment appointment,
  ) {
    return BookingModel(
      timeRange: customData.timeRange,
      description: customData.description,
      title: customData.title,
      recurrenceState: customData.recurrenceState,
      location: customData.location,
      createdAt: customData.createdAt,
      host: customData.host,
      userId: customData.userId,
      id: customData.id,
    );
  }
}
