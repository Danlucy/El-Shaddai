import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/controller/auth_controller.dart';
import 'package:mobile/features/booking/controller/booking_controller.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:util/util.dart';

import '../../../core/widgets/loader.dart';
import '../../booking/presentations/booking_dialog.dart';
import '../widget/booking_details_dialog.dart';

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
  // A simple counter to track the appointment index for alternating colors
  int _appointmentCounter = 0;

  // This helper method is now a static function or a top-level function
  // to prevent it from being tightly coupled to the widget's state.
  static _AppointmentDataSource _getCalendarDataSource(
    List<BookingModel> bookingModels,
  ) {
    List<BookingModel> appointments = <BookingModel>[];

    for (BookingModel booking in bookingModels) {
      int duration = booking.timeRange.end
          .difference(booking.timeRange.start)
          .inDays;

      for (int i = 0; i <= duration; i++) {
        DateTime currentDate = DateTime(
          booking.timeRange.start.year,
          booking.timeRange.start.month,
          booking.timeRange.start.day + i,
        );

        DateTime startTime;
        DateTime endTime;

        if (i == 0) {
          startTime = booking.timeRange.start;
        } else {
          startTime = DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
            0,
            0,
          );
        }

        if (i == duration) {
          endTime = booking.timeRange.end;
        } else {
          endTime = DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
            23,
            59,
            59,
          );
        }

        appointments.add(
          BookingModel(
            timeRange: CustomDateTimeRange(start: startTime, end: endTime),
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

  @override
  Widget build(BuildContext context) {
    ref.watch(bookingControllerProvider);
    final bookingStream = ref.watch(bookingStreamProvider());
    final bookingFunction = ref.read(bookingControllerProvider.notifier);
    // final selectedDate = ref.watch(calendarDateNotifierProvider);
    final user = ref.watch(userProvider);
    ref.listen(calendarDateNotifierProvider, (previous, next) {
      widget.dailyCalendarController.displayDate = next;
      widget.dailyCalendarController.selectedDate = next;
    });

    return bookingStream.when(
      data: (data) {
        final dataSource = _getCalendarDataSource(data);

        // IMPORTANT: Reset the counter for each frame build.
        _appointmentCounter = 0;

        return SfCalendar(
          headerHeight: 0,
          viewHeaderHeight: 0,
          onViewChanged: (ViewChangedDetails details) {
            // When user navigates in daily view, update the shared state
            if (details.visibleDates.isNotEmpty) {
              final visibleDate = details.visibleDates.first;
              final currentSelected = ref.read(calendarDateNotifierProvider);

              if (currentSelected.day != visibleDate.day ||
                  currentSelected.month != visibleDate.month ||
                  currentSelected.year != visibleDate.year) {
                // CORRECTED: Delay the provider modification until the next frame.
                // This prevents the error from being thrown.
                Future.microtask(() {
                  ref
                      .read(calendarDateNotifierProvider.notifier)
                      .updateSelectedDate(visibleDate);
                });
              }
            }
          },
          onLongPress: (CalendarLongPressDetails tapped) {
            if (user.value?.role == UserRole.observer ||
                user.value?.role == UserRole.intercessor) {
              return;
            } //cancel operation if obs or intercessor role

            bookingFunction.clearState();
            if (tapped.date != null) {
              bookingFunction.setStartTime(tapped.date!, context);
              bookingFunction.setEndTime(
                tapped.date!.add(const Duration(minutes: 30)),
                context,
              );
              bookingFunction.setDateRange(
                DateTimeRange(start: tapped.date!, end: tapped.date!),
              );
            }

            showDialog(
              useRootNavigator: false,
              context: context,
              builder: (context) {
                return BookingDialog(context);
              },
            );
          },
          appointmentBuilder:
              (BuildContext context, CalendarAppointmentDetails details) {
                final appointment = details.appointments.first as BookingModel;

                // Use the counter to determine the alternating color.
                final backgroundColor = _appointmentCounter % 2 == 0
                    ? context.colors.primaryContainer
                    : context.colors.secondaryContainer;

                // IMPORTANT: Increment the counter for the next appointment.
                _appointmentCounter++;

                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return BookingDetailsDialog(bookingModel: appointment);
                      },
                    );
                  },
                  child: Container(
                    color: backgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: context.colors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
          dataSource: dataSource,
          controller: widget.dailyCalendarController,
          view: CalendarView.day,
          timeSlotViewSettings: const TimeSlotViewSettings(
            timeRulerSize: 80,
            timeIntervalHeight: 80,
            timeFormat: 'hh:mm a',
            timeInterval: Duration(minutes: 30),
          ),
        );
      },
      error: (error, stack) {
        return const Center(child: Text('Error'));
      },
      loading: () => const Loader(),
    );
  }
}

// ... The rest of your code remains unchanged.

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
