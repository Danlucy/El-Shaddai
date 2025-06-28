import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../core/utility/date_time_range.dart';
import '../../../core/widgets/loader.dart';
import '../../../models/booking_model/booking_model.dart';
import '../../booking/repository/booking_repository.dart';
import '../controller/calendar_controller.dart';

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

class _MonthlyCalendarComponentState
    extends ConsumerState<MonthlyCalendarComponent> {
  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(calendarDateNotifierProvider);
    MonthlyCalendarController controller = MonthlyCalendarController();
    ref.listen(
      calendarDateNotifierProvider,
      (previous, next) {
        widget.monthlyCalendarController.selectedDate = next;
      },
    );
    return ref.watch(bookingStreamProvider()).when(
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

              bool fullyBooked =
                  controller.isFullyBooked(details.date, bookings);
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
                        padding: EdgeInsets.only(top: isSelected ? 0 : 3),
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
