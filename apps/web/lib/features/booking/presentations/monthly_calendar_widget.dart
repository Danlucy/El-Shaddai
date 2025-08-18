import 'dart:math';

import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl/intl.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:util/util.dart';
import 'package:website/core/widgets/loader.dart';
import 'package:website/features/booking/controller/booking_controller.dart';
import 'package:website/features/booking/presentations/daily_booking_dialog.dart';

class MonthlyCalendarComponent extends ConsumerStatefulWidget {
  const MonthlyCalendarComponent({
    super.key,
  });

  @override
  ConsumerState<MonthlyCalendarComponent> createState() =>
      _WebCalendarComponentState();
}

class _WebCalendarComponentState extends ConsumerState<MonthlyCalendarComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController _gradientAnimationController;
  late Animation<double> _gradientAnimation;
  late CalendarController _calendarController;

  DateTime? _previousSelectedDate;
  bool _isUpdatingFromProvider = false; // Flag to prevent circular updates

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

    // Initialize internal calendar controller
    _calendarController = CalendarController();

    // Set initial date after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedDate = ref.read(calendarDateNotifierProvider);
      _updateCalendarController(selectedDate);
    });
  }

  @override
  void dispose() {
    _gradientAnimationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  // Centralized method to update calendar controller
  void _updateCalendarController(DateTime date) {
    print('Updating calendar controller to: $date');
    _isUpdatingFromProvider = true;

    // Only update if the date is actually different to prevent unnecessary updates
    if (_calendarController.selectedDate != date) {
      _calendarController.selectedDate = date;
    }
    if (_calendarController.displayDate?.month != date.month ||
        _calendarController.displayDate?.year != date.year) {
      _calendarController.displayDate = date;
    }

    // Reset flag after a brief delay to allow calendar to update
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        _isUpdatingFromProvider = false;
      }
    });
  }

  // Utility to get the grid position (row and column) of a date
  Point<int> _getGridPosition(DateTime date, DateTime displayDate) {
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
    final displayDate = _calendarController.displayDate ?? targetDate;

    final targetPos = _getGridPosition(targetDate, displayDate);
    final currentPos = _getGridPosition(date, displayDate);

    final rowDiff = targetPos.y - currentPos.y;
    final colDiff = targetPos.x - currentPos.x;

    final distance = (rowDiff.abs() + colDiff.abs()).toDouble();

    if (distance == 0) {
      return {
        'distance': 0.0,
        'start': Alignment.center,
        'end': Alignment.center,
        'intensity': 0.0
      };
    }

    Alignment gradientStart;
    Alignment gradientEnd;

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

    final intensity = 0.4 / (distance + 0);

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
    final screenWidth = MediaQuery.of(context).size.width;

    // Handle date changes from provider
    if (_previousSelectedDate != selectedDate) {
      print(
          'Selected date changed from $_previousSelectedDate to $selectedDate');
      _previousSelectedDate = selectedDate;
      _gradientAnimationController.reset();
      _gradientAnimationController.forward();

      // Update calendar controller when provider changes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isUpdatingFromProvider && mounted) {
          _updateCalendarController(selectedDate);
        }
      });
    }

    // Listen to provider changes - but avoid circular updates
    ref.listen(
      calendarDateNotifierProvider,
      (previous, next) {
        print(
            'Provider listener: $previous -> $next, isUpdating: $_isUpdatingFromProvider');
        if (!_isUpdatingFromProvider && previous != next && mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _updateCalendarController(next);
            }
          });
        }
      },
    );

    // Web-optimized text scaling - simpler approach for web
    final bool isLargeText =
        ResponsiveValue(context, defaultValue: false, conditionalValues: [
      Condition.smallerThan(name: MOBILE, value: false),
      Condition.between(start: 450, end: 800, value: true),
      Condition.largerThan(name: TABLET, value: true),
    ]).value;

    // Extract date components
    final dayOfWeek = DateFormat('EEE').format(selectedDate);
    final dayOfMonth = DateFormat('d').format(selectedDate);
    final monthOfMonth = DateFormat('MMMM ').format(selectedDate);
    final yearOfMonth = DateFormat('yyyy').format(selectedDate);

    return AnimatedBuilder(
      animation: _gradientAnimation,
      builder: (context, child) {
        return ref.watch(bookingStreamProvider()).when(
              data: (data) {
                // Create a controller instance for checking booking status
                MonthlyCalendarController controller =
                    MonthlyCalendarController();

                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Date Display Header - moved to top for web layout
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: GlassmorphicContainer(
                        height: 60,
                        width: double.infinity,
                        border: 1,
                        blur: 10,
                        borderGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            context.colors.secondary.withOpac(0.1),
                            context.colors.primary.withOpac(0.1),
                          ],
                        ),
                        linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            context.colors.secondary.withOpac(0.1),
                            context.colors.primary.withOpac(0.1),
                          ],
                        ),
                        borderRadius: 12,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text: '$dayOfWeek, '.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: isLargeText ? 24 : 20,
                                    fontWeight: FontWeight.normal,
                                    color:
                                        context.colors.secondary.withOpac(0.8),
                                  ),
                                ),
                                TextSpan(
                                  text: '$dayOfMonth ',
                                  style: TextStyle(
                                    fontSize: isLargeText ? 28 : 26,
                                    fontWeight: FontWeight.bold,
                                    color: context.colors.secondary,
                                  ),
                                ),
                                TextSpan(
                                  text: monthOfMonth,
                                  style: TextStyle(
                                    fontSize: isLargeText ? 26 : 22,
                                    fontWeight: FontWeight.bold,
                                    color: context.colors.primary.withOpac(0.8),
                                  ),
                                ),
                                TextSpan(
                                  text: yearOfMonth,
                                  style: TextStyle(
                                    fontSize: isLargeText ? 22 : 18,
                                    fontWeight: FontWeight.normal,
                                    color:
                                        context.colors.secondary.withOpac(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Calendar Component
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SfCalendar(
                            headerStyle: CalendarHeaderStyle(
                                textStyle:
                                    TextStyle(fontSize: isLargeText ? 24 : 20),
                                backgroundColor: Colors.transparent),
                            headerHeight:
                                ResponsiveValue(context, conditionalValues: [
                              Condition.smallerThan(name: MOBILE, value: 60),
                              Condition.between(
                                  start: 450, end: 800, value: 70),
                              Condition.largerThan(name: TABLET, value: 80),
                            ]).value.toDouble(),
                            viewNavigationMode: ViewNavigationMode.none,
                            showNavigationArrow: true,
                            dataSource: BookingDataSource(data),
                            controller: _calendarController,
                            initialSelectedDate: selectedDate,

                            // IMPORTANT: Handle calendar's internal selection changes
                            onSelectionChanged:
                                (CalendarSelectionDetails details) {
                              print(
                                  'Calendar selection changed to: ${details.date}, isUpdating: $_isUpdatingFromProvider');
                              if (details.date != null &&
                                  !_isUpdatingFromProvider) {
                                final normalizedDate = DateTime(
                                  details.date!.year,
                                  details.date!.month,
                                  details.date!.day,
                                );

                                print(
                                    'Updating provider from calendar selection: $normalizedDate');
                                // Use Future.microtask to delay provider update
                                Future.microtask(() {
                                  ref
                                      .read(
                                          calendarDateNotifierProvider.notifier)
                                      .updateSelectedDate(normalizedDate);
                                });
                              }
                            },

                            // Handle view changes (month navigation)
                            onViewChanged: (ViewChangedDetails details) {
                              print('View changed: ${details.visibleDates}');
                              // IMPORTANT: Don't update selected date on view changes
                              // This was causing the calendar to revert to today's date
                            },

                            monthViewSettings: const MonthViewSettings(
                              appointmentDisplayCount: 0,
                            ),
                            monthCellBuilder: (BuildContext context,
                                MonthCellDetails details) {
                              // Use _calendarController.displayDate with fallback
                              final currentDisplayDate =
                                  _calendarController.displayDate ??
                                      selectedDate;

                              bool isCurrentMonth = details.date.month ==
                                  currentDisplayDate.month;

                              // Normalize dates for comparison (ignore time component)
                              final normalizedDetailDate = DateTime(
                                details.date.year,
                                details.date.month,
                                details.date.day,
                              );
                              final normalizedSelectedDate = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                              );

                              bool isSelectedDate = normalizedDetailDate ==
                                  normalizedSelectedDate;

                              final gradientInfo = _getCellGradientInfo(
                                  details.date,
                                  selectedDate,
                                  _previousSelectedDate,
                                  _gradientAnimation.value);

                              final intensity =
                                  gradientInfo['intensity'] as double;
                              final gradientStart =
                                  gradientInfo['start'] as Alignment;
                              final gradientEnd =
                                  gradientInfo['end'] as Alignment;

                              List<BookingModel> bookings =
                                  data.where((element) {
                                return isOverlapping(
                                    details.date, element.timeRange);
                              }).toList();
                              bool isBooked = bookings.isNotEmpty;

                              bool fullyBooked = controller.isFullyBooked(
                                  details.date, bookings);

                              return MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: isSelectedDate
                                        ? Border.all(
                                            color: context.colors.secondary,
                                            width: 2.5,
                                          )
                                        : Border.all(
                                            width: 0.3,
                                            color:
                                                Colors.grey.withOpacity(0.4)),
                                  ),
                                  child: GestureDetector(
                                    onDoubleTap: () {
                                      print('Double tap on: ${details.date}');

                                      final normalizedDate = DateTime(
                                        details.date.year,
                                        details.date.month,
                                        details.date.day,
                                      );

                                      // Use Future.microtask to delay provider update
                                      Future.microtask(() {
                                        ref
                                            .read(calendarDateNotifierProvider
                                                .notifier)
                                            .updateSelectedDate(normalizedDate);

                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const DailyBookingDialog(),
                                        );
                                      });
                                    },
                                    onTap: () {
                                      print('Tap on: ${details.date}');

                                      final normalizedDate = DateTime(
                                        details.date.year,
                                        details.date.month,
                                        details.date.day,
                                      );

                                      // Use Future.microtask to delay provider update
                                      Future.microtask(() {
                                        ref
                                            .read(calendarDateNotifierProvider
                                                .notifier)
                                            .updateSelectedDate(normalizedDate);
                                      });
                                    },
                                    child: Center(
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
                                                        .withOpac(
                                                            intensity * 0.25),
                                                    context.colors.secondary
                                                        .withOpac(
                                                            intensity * 0.5),
                                                    context.colors.secondary
                                                        .withOpac(
                                                            intensity * 0.8),
                                                  ],
                                                  stops: const [
                                                    0.0,
                                                    0.3,
                                                    0.7,
                                                    1.0
                                                  ],
                                                ),
                                              ),
                                            ),
                                          Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    details.date.day.toString(),
                                                    style: TextStyle(
                                                      fontSize: isSelectedDate
                                                          ? (isLargeText
                                                              ? 22
                                                              : 18)
                                                          : (isLargeText
                                                              ? 20
                                                              : 16),
                                                      fontWeight: intensity >
                                                                  0.15 ||
                                                              isSelectedDate
                                                          ? FontWeight.w600
                                                          : FontWeight.normal,
                                                      color: !isCurrentMonth
                                                          ? Colors.grey
                                                              .withOpacity(0.6)
                                                          : isSelectedDate
                                                              ? context.colors
                                                                  .secondary
                                                              : intensity > 0.15
                                                                  ? context
                                                                      .colors
                                                                      .secondary
                                                                      .withOpac(
                                                                          0.9)
                                                                  : Colors
                                                                      .white,
                                                    ),
                                                  ),
                                                  if (isBooked) ...[
                                                    const SizedBox(height: 2),
                                                    CircleAvatar(
                                                      radius: isSelectedDate
                                                          ? 4.5
                                                          : 3.5,
                                                      backgroundColor:
                                                          fullyBooked
                                                              ? Colors.red
                                                                  .withOpacity(
                                                                      0.9)
                                                              : Colors.green
                                                                  .withOpacity(
                                                                      0.9),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            showCurrentTimeIndicator: false,
                            showDatePickerButton: true,
                            view: CalendarView.month,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              error: (error, stack) {
                return Container(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: const Center(
                      child: Text(
                        'Error loading calendar',
                        style: TextStyle(color: Colors.red),
                      ),
                    ));
              },
              loading: () => Container(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: const Loader(),
              ),
            );
      },
    );
  }
}
