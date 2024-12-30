import 'package:collection/collection.dart';
import 'package:el_shaddai/core/customs/custom_date_time_range.dart';
import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/core/utility/date_time_range.dart';
import 'package:el_shaddai/features/auth/widgets/loader.dart';
import 'package:el_shaddai/features/booking/repository/booking_repository.dart';
import 'package:el_shaddai/features/calendar/controller/calendar_controller.dart';
import 'package:el_shaddai/models/booking_model/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MonthlyCalendarComponent extends ConsumerStatefulWidget {
  const MonthlyCalendarComponent({
    required this.monthlyCalendarController,
    super.key,
  });
  final CalendarController monthlyCalendarController;

  @override
  ConsumerState<MonthlyCalendarComponent> createState() =>
      _MonthlyCalendarComponentState();
}

bool isOverlapping(DateTime date, CustomDateTimeRange timeRange) {
  // Create DateTime for the start and end of the given date
  final startOfDay = DateTime(date.year, date.month, date.day);
  final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

  return (timeRange.start.isBefore(endOfDay)) &&
      (timeRange.end.isAfter(startOfDay));
}

class _MonthlyCalendarComponentState
    extends ConsumerState<MonthlyCalendarComponent> {
  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(calendarDateNotifierProvider);
    ref.listen(
      calendarDateNotifierProvider,
      (previous, next) {
        widget.monthlyCalendarController.selectedDate = next;
      },
    );
    return ref.watch(bookingsProvider).when(
        data: (data) {
          return SfCalendar(
            dataSource: BookingDataSource(data),
            controller: widget.monthlyCalendarController,
            initialSelectedDate: selectedDate,
            monthViewSettings: const MonthViewSettings(
              appointmentDisplayCount: 0,
            ),
            monthCellBuilder: (BuildContext context, MonthCellDetails details) {
              bool isCurrentMonth = details.date.month ==
                  widget.monthlyCalendarController.displayDate!.month;
              final isSelected = details.date == selectedDate;
              List<BookingModel> bookings = data.where((element) {
                // print(' ${element.timeRange} ${element.appointmentTimeRange}');
                return isOverlapping(details.date, element.timeRange);
              }).toList();
              bool isBooked = bookings.isNotEmpty;
              bool fullyBooked = false;
              if (bookings.isNotEmpty) {
                List<BookingModel> splitBookingsIntoDays(
                    List<BookingModel> bookings) {
                  List<BookingModel> splitBookings = [];

                  for (BookingModel booking in bookings) {
                    int duration =
                        booking.timeRange.end.day - booking.timeRange.start.day;
                    for (int i = 0; i < duration + 1; i++) {
                      DateTime appointmentDate =
                          booking.timeRange.start.add(Duration(days: i));

                      // For the first day, set the start time to the original start time
                      DateTime currentStartTime = (i == 0)
                          ? booking.timeRange.start
                          : DateTime(appointmentDate.year,
                              appointmentDate.month, appointmentDate.day, 0, 0);

                      // For the last day, set the end time to the original end time
                      DateTime currentEndTime = (i == duration)
                          ? booking.timeRange.end
                          : DateTime(
                              appointmentDate.year,
                              appointmentDate.month,
                              appointmentDate.day,
                              23,
                              59);

                      splitBookings.add(BookingModel(
                          timeRange: CustomDateTimeRange(
                              start: currentStartTime, end: currentEndTime),
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

                  return splitBookings;
                }

                // print('TRACK');
                // print(details.date);
                // print(splitBookingsIntoDays(bookings));

                double sumBookingDurationsByDate(List<BookingModel> bookings) {
                  final dd = bookings.where((element) {
                    // print(' ${element.timeRange} ${element.appointmentTimeRange}');
                    return isOverlapping(details.date, element.timeRange);
                  });

                  final total = dd.fold<double>(
                      0,
                      (sum, booking) =>
                          sum + booking.timeRange.duration.inMinutes);

                  return total;
                }

                fullyBooked = (sumBookingDurationsByDate(
                        splitBookingsIntoDays(bookings)) >=
                    1439);
                // print(' ${details.date}$totalBookedMinutes');
              }
              return Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: isSelected
                        ? Border.all(
                            color: context.colors.secondary,
                            width: 2,
                          )
                        : Border.all(width: 0.2, color: Colors.grey)),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        details.date.day.toString(),
                        style: TextStyle(
                          fontSize: isSelected ? 16 : null,
                          color: !isCurrentMonth
                              ? Colors
                                  .grey // Color for dates outside current month
                              : details.date == selectedDate
                                  ? context.colors.secondary
                                  : Colors.white,
                        ),
                      ),
                    ),
                    if (isBooked)
                      Padding(
                        padding: EdgeInsets.only(top: isSelected ? 1 : 4),
                        child: CircleAvatar(
                          radius: isSelected ? 4 : 3,
                          backgroundColor:
                              fullyBooked ? Colors.green : Colors.red,
                        ),
                      )
                    else
                      Container(),
                  ],
                ),
              );
            },
            onTap: (details) {
              ref
                  .read(calendarDateNotifierProvider.notifier)
                  .updateSelectedDate(details.date!);
            },
            showNavigationArrow: true,
            view: CalendarView.month,
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
