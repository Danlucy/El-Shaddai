import 'dart:math';
import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/widgets/glass_container.dart';
import 'package:mobile/features/booking/presentations/booking_screen.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:util/util.dart';

import '../../../core/widgets/loader.dart';

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
    extends ConsumerState<MonthlyCalendarComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController _gradientAnimationController;
  late Animation<double> _gradientAnimation;

  DateTime? _previousSelectedDate;

  @override
  void initState() {
    super.initState();

    _gradientAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _gradientAnimation = CurvedAnimation(
      parent: _gradientAnimationController,
      curve: Curves.easeInOutCubic,
    );

    _gradientAnimationController.value = 1.0;
  }

  @override
  void dispose() {
    _gradientAnimationController.dispose();
    super.dispose();
  }

  // --- NEW Helper Methods for Gradient Calculation ---

  // Utility to get the grid position (row and column) of a date
  Point<int> _getGridPosition(DateTime date, DateTime displayDate) {
    // Get the first day of the week for the first day of the month view
    final firstDayOfMonth = DateTime(displayDate.year, displayDate.month, 1);
    final firstDayInView =
        firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday % 7));

    final dayDifference = date.difference(firstDayInView).inDays;
    final row = dayDifference ~/ 7;
    final col = dayDifference % 7;
    return Point<int>(col, row);
  }

  // Calculate gradient direction and intensity for each cell with animation
  Map<String, dynamic> _getCellGradientInfo(
      DateTime date,
      DateTime selectedDate,
      DateTime? previousSelectedDate,
      double animationValue) {
    Map<String, dynamic> currentGradientInfo =
        _calculateGradientForDate(date, selectedDate);
    Map<String, dynamic> previousGradientInfo = previousSelectedDate != null
        ? _calculateGradientForDate(date, previousSelectedDate)
        : {
            'distance': 10.0,
            'start': Alignment.center,
            'end': Alignment.center,
            'intensity': 0.0
          };

    final currentIntensity = currentGradientInfo['intensity'] as double;
    final previousIntensity = previousGradientInfo['intensity'] as double;

    final interpolatedIntensity = previousIntensity +
        (currentIntensity - previousIntensity) * animationValue;

    return {
      'distance': currentGradientInfo['distance'],
      'start': currentGradientInfo['start'],
      'end': currentGradientInfo['end'],
      'intensity': interpolatedIntensity,
    };
  }

  // Helper method to calculate gradient for a specific date using Manhattan distance
  Map<String, dynamic> _calculateGradientForDate(
      DateTime date, DateTime targetDate) {
    // Ensure we are comparing dates within the same month's view
    final displayDate =
        widget.monthlyCalendarController.displayDate ?? targetDate;

    final targetPos = _getGridPosition(targetDate, displayDate);
    final currentPos = _getGridPosition(date, displayDate);

    // Calculate row and column differences
    final rowDiff = targetPos.y - currentPos.y;
    final colDiff = targetPos.x - currentPos.x;

    // Use Manhattan distance
    final distance = (rowDiff.abs() + colDiff.abs()).toDouble();

    // The selected cell has no distance and no intensity
    if (distance == 0) {
      return {
        'distance': 0.0,
        'start': Alignment.center,
        'end': Alignment.center,
        'intensity': 0.0
      };
    }

    // Determine gradient direction based on relative position
    Alignment gradientStart;
    Alignment gradientEnd;

    // The rest of the logic remains similar to determine the direction
    if (rowDiff > 0 && colDiff == 0) {
      gradientStart = Alignment.topCenter;
      gradientEnd = Alignment.bottomCenter;
    } else if (rowDiff < 0 && colDiff == 0) {
      gradientStart = Alignment.bottomCenter;
      gradientEnd = Alignment.topCenter;
    } else if (rowDiff == 0 && colDiff > 0) {
      gradientStart = Alignment.centerLeft;
      gradientEnd = Alignment.centerRight;
    } else if (rowDiff == 0 && colDiff < 0) {
      gradientStart = Alignment.centerRight;
      gradientEnd = Alignment.centerLeft;
    } else if (rowDiff > 0 && colDiff > 0) {
      gradientStart = Alignment.topLeft;
      gradientEnd = Alignment.bottomRight;
    } else if (rowDiff > 0 && colDiff < 0) {
      gradientStart = Alignment.topRight;
      gradientEnd = Alignment.bottomLeft;
    } else if (rowDiff < 0 && colDiff > 0) {
      gradientStart = Alignment.bottomLeft;
      gradientEnd = Alignment.topRight;
    } else if (rowDiff < 0 && colDiff < 0) {
      gradientStart = Alignment.bottomRight;
      gradientEnd = Alignment.topLeft;
    } else {
      gradientStart = Alignment.center;
      gradientEnd = Alignment.center;
    }

    // Use a continuous-like function for intensity to ensure a smooth fade-out
    // The intensity will be stronger for cells closer to the selected date
    final intensity =
        0.4 / (distance + 0); // Adjust the numerator for desired max intensity

    return {
      'distance': distance,
      'start': gradientStart,
      'end': gradientEnd,
      'intensity': intensity,
    };
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(calendarDateNotifierProvider);
    MonthlyCalendarController controller = MonthlyCalendarController();

    if (_previousSelectedDate != selectedDate) {
      _previousSelectedDate = selectedDate;

      _gradientAnimationController.reset();
      _gradientAnimationController.forward();
    }

    ref.listen(
      calendarDateNotifierProvider,
      (previous, next) {
        if (widget.monthlyCalendarController.displayDate != next) {
          widget.monthlyCalendarController.selectedDate = next;
          widget.monthlyCalendarController.displayDate = next;
        }
      },
    );

    final bool isOldMan = TextScaleFactor.scaleFactor(
          MediaQuery.textScalerOf(context).scale(1),
        ) ==
        TextScaleFactor.oldMan;

    // Extract the individual date components
    final dayOfWeek = DateFormat('EEE').format(selectedDate);
    final dayOfMonth = DateFormat('d').format(selectedDate);
    final monthOfMonth = DateFormat('MMMM ').format(selectedDate);
    final yearOfMonth = DateFormat('yyyy').format(selectedDate);

    return AnimatedBuilder(
      animation: _gradientAnimation,
      builder: (context, child) {
        return ref.watch(bookingStreamProvider()).when(
              data: (data) {
                return Column(
                  children: [
                    Expanded(
                      child: SfCalendar(
                        headerHeight: 0,
                        showNavigationArrow: false,
                        dataSource: BookingDataSource(data),
                        controller: widget.monthlyCalendarController,
                        initialSelectedDate: selectedDate,
                        monthViewSettings: const MonthViewSettings(
                          appointmentDisplayCount: 0,
                        ),
                        monthCellBuilder:
                            (BuildContext context, MonthCellDetails details) {
                          bool isCurrentMonth = details.date.month ==
                              widget
                                  .monthlyCalendarController.displayDate!.month;
                          bool isSelectedDate = details.date == selectedDate;

                          final gradientInfo = _getCellGradientInfo(
                              details.date,
                              selectedDate,
                              _previousSelectedDate,
                              _gradientAnimation.value);

                          final intensity = gradientInfo['intensity'] as double;
                          final gradientStart =
                              gradientInfo['start'] as Alignment;
                          final gradientEnd = gradientInfo['end'] as Alignment;

                          List<BookingModel> bookings = data.where((element) {
                            return isOverlapping(
                                details.date, element.timeRange);
                          }).toList();
                          bool isBooked = bookings.isNotEmpty;

                          bool fullyBooked =
                              controller.isFullyBooked(details.date, bookings);

                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: isSelectedDate
                                  ? Border.all(
                                      color: context.colors.secondary,
                                      width: 2.0,
                                    )
                                  : Border.all(width: 0.2, color: Colors.grey),
                            ),
                            child: Stack(
                              children: [
                                if (intensity > 0)
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: gradientStart,
                                        end: gradientEnd,
                                        colors: [
                                          Colors.transparent,
                                          context.colors.secondary
                                              .withOpac(intensity * 0.3),
                                          context.colors.secondary
                                              .withOpac(intensity * 0.6),
                                          context.colors.secondary
                                              .withOpac(intensity),
                                        ],
                                        stops: const [0.0, 0.3, 0.7, 1.0],
                                      ),
                                    ),
                                  ),
                                Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        details.date.day.toString(),
                                        style: TextStyle(
                                          fontSize: isSelectedDate
                                              ? (isOldMan ? 12 : 18)
                                              : (isOldMan ? 10 : 16),
                                          fontWeight:
                                              intensity > 0.15 || isSelectedDate
                                                  ? FontWeight.w500
                                                  : FontWeight.normal,
                                          color: !isCurrentMonth
                                              ? Colors.grey
                                              : isSelectedDate
                                                  ? context.colors.secondary
                                                  : intensity > 0.15
                                                      ? context.colors.secondary
                                                          .withOpac(0.9)
                                                      : Colors.white,
                                        ),
                                      ),
                                    ),
                                    if (isBooked)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: isSelectedDate
                                                ? 0
                                                : (isOldMan ? 2 : 3)),
                                        child: CircleAvatar(
                                          radius: isSelectedDate
                                              ? (isOldMan ? 3.5 : 4)
                                              : 3,
                                          backgroundColor: fullyBooked
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      )
                                    else
                                      Container(),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        onTap: (details) {
                          if (details.date != null) {
                            ref
                                .read(calendarDateNotifierProvider.notifier)
                                .updateSelectedDate(details.date!);
                          }
                        },
                        view: CalendarView.month,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 2),
                        child: IntrinsicHeight(
                          child: GlassContainer(
                            borderRadius: BorderRadius.circular(8),
                            child: Center(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '$dayOfWeek, '.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                        color: context.colors.secondary
                                            .withOpac(0.8),
                                      ),
                                    ),
                                    TextSpan(
                                      text: '$dayOfMonth ',
                                      style: TextStyle(
                                        fontSize:
                                            22, // Large font size for the date
                                        fontWeight: FontWeight
                                            .bold, // Bold for the date
                                        color: context.colors.secondary,
                                      ),
                                    ),
                                    TextSpan(
                                      text: monthOfMonth,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: context.colors.primary
                                            .withOpac(0.8),
                                      ),
                                    ),
                                    TextSpan(
                                      text: yearOfMonth,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: context.colors.secondary
                                            .withOpac(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                  ],
                );
              },
              error: (error, stack) {
                return const Center(
                  child: Text('Error'),
                );
              },
              loading: () => const Loader(),
            );
      },
    );
  }
}
