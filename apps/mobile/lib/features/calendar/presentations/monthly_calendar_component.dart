import 'package:constants/constants.dart';
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
    extends ConsumerState<MonthlyCalendarComponent>
    with TickerProviderStateMixin {
  late AnimationController _gradientAnimationController;
  late AnimationController _selectionAnimationController;
  late Animation<double> _gradientAnimation;
  late Animation<double> _selectionAnimation;

  DateTime? _previousSelectedDate;
  DateTime? _currentSelectedDate;

  // Animation values for smooth transitions
  Offset? _previousSelectionPosition;
  Offset? _currentSelectionPosition;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for gradient transitions
    _gradientAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Initialize animation controller for selection box movement
    _selectionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _gradientAnimation = CurvedAnimation(
      parent: _gradientAnimationController,
      curve: Curves.easeInOutCubic,
    );

    _selectionAnimation = CurvedAnimation(
      parent: _selectionAnimationController,
      curve: Curves.easeInOutQuart,
    );

    // Start with animations completed
    _gradientAnimationController.value = 1.0;
    _selectionAnimationController.value = 1.0;
  }

  @override
  void dispose() {
    _gradientAnimationController.dispose();
    _selectionAnimationController.dispose();
    super.dispose();
  }

  // Calculate gradient direction and intensity for each cell with animation
  Map<String, dynamic> _getCellGradientInfo(
      DateTime date,
      DateTime selectedDate,
      DateTime? previousSelectedDate,
      double animationValue) {
    // Calculate both current and previous gradient info for animation
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

    // Interpolate between previous and current gradient
    final currentIntensity = currentGradientInfo['intensity'] as double;
    final previousIntensity = previousGradientInfo['intensity'] as double;

    final interpolatedIntensity = previousIntensity +
        (currentIntensity - previousIntensity) * animationValue;

    return {
      'distance': currentGradientInfo['distance'],
      'start': currentGradientInfo['start'],
      'end': currentGradientInfo['end'],
      'intensity': interpolatedIntensity,
      'isAnimating': animationValue < 1.0,
    };
  }

  // Helper method to calculate gradient for a specific date
  Map<String, dynamic> _calculateGradientForDate(
      DateTime date, DateTime targetDate) {
    // Get the first day of the month for grid calculations
    final firstDayOfMonth = DateTime(targetDate.year, targetDate.month, 1);
    final targetDaysFromFirst = targetDate.difference(firstDayOfMonth).inDays;
    final dateDaysFromFirst = date.difference(firstDayOfMonth).inDays;

    // Calculate grid coordinates
    final targetWeekDay = (targetDate.weekday % 7);
    final dateWeekDay = (date.weekday % 7);

    final targetRow = targetDaysFromFirst ~/ 7;
    final targetCol = targetWeekDay;

    final dateRow = dateDaysFromFirst ~/ 7;
    final dateCol = dateWeekDay;

    // Calculate direction vector from current cell to target cell
    final rowDiff = targetRow - dateRow;
    final colDiff = targetCol - dateCol;

    // Calculate distance for intensity
    final distance = [rowDiff.abs(), colDiff.abs()]
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    // Calculate gradient alignment based on direction
    Alignment gradientStart;
    Alignment gradientEnd;

    if (distance == 0) {
      // Selected cell - no gradient
      return {
        'distance': distance,
        'start': Alignment.center,
        'end': Alignment.center,
        'intensity': 0.0
      };
    }

    // Determine gradient direction based on relative position
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

    // Calculate intensity based on distance
    double intensity;
    if (distance == 1)
      intensity = 0.25;
    else if (distance == 2)
      intensity = 0.15;
    else if (distance == 3)
      intensity = 0.08;
    else
      intensity = 0.0;

    return {
      'distance': distance,
      'start': gradientStart,
      'end': gradientEnd,
      'intensity': intensity,
    };
  }

  // Calculate selection border animation properties
  Map<String, dynamic> _getSelectionBorderInfo(
      DateTime date,
      DateTime selectedDate,
      DateTime? previousSelectedDate,
      double selectionAnimationValue) {
    final isCurrentlySelected = date == selectedDate;
    final wasPreviouslySelected =
        previousSelectedDate != null && date == previousSelectedDate;

    // Handle different selection states
    if (isCurrentlySelected && !wasPreviouslySelected) {
      // New selection - animate in
      return {
        'borderWidth': 2.0 * selectionAnimationValue,
        'borderOpacity': selectionAnimationValue,
        'scale': 0.95 + (0.05 * selectionAnimationValue),
      };
    } else if (!isCurrentlySelected && wasPreviouslySelected) {
      // Previous selection - animate out
      return {
        'borderWidth': 2.0 * (1.0 - selectionAnimationValue),
        'borderOpacity': 1.0 - selectionAnimationValue,
        'scale': 1.0 - (0.05 * selectionAnimationValue),
      };
    } else if (isCurrentlySelected && wasPreviouslySelected) {
      // Same selection - keep full
      return {
        'borderWidth': 2.0,
        'borderOpacity': 1.0,
        'scale': 1.0,
      };
    } else {
      // Not selected - no border
      return {
        'borderWidth': 0.0,
        'borderOpacity': 0.0,
        'scale': 1.0,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(calendarDateNotifierProvider);
    MonthlyCalendarController controller = MonthlyCalendarController();

    // Check if selected date changed and trigger animations
    if (_previousSelectedDate != selectedDate) {
      _currentSelectedDate = selectedDate;

      _previousSelectedDate = selectedDate;

      // Start both animations
      _gradientAnimationController.reset();
      _selectionAnimationController.reset();

      _gradientAnimationController.forward();
      _selectionAnimationController.forward();
    }

    ref.listen(
      calendarDateNotifierProvider,
      (previous, next) {
        widget.monthlyCalendarController.selectedDate = next;
      },
    );

    return AnimatedBuilder(
      animation: Listenable.merge([_gradientAnimation, _selectionAnimation]),
      builder: (context, child) {
        return ref.watch(bookingStreamProvider()).when(
              data: (data) {
                return SfCalendar(
                  dataSource: BookingDataSource(data),
                  controller: widget.monthlyCalendarController,
                  initialSelectedDate: selectedDate,
                  monthViewSettings: const MonthViewSettings(
                    appointmentDisplayCount: 0,
                  ),
                  monthCellBuilder:
                      (BuildContext context, MonthCellDetails details) {
                    bool isCurrentMonth = details.date.month ==
                        widget.monthlyCalendarController.displayDate!.month;

                    // Get animated gradient info for this cell
                    final gradientInfo = _getCellGradientInfo(
                        details.date,
                        selectedDate,
                        _previousSelectedDate,
                        _gradientAnimation.value);

                    final intensity = gradientInfo['intensity'] as double;
                    final gradientStart = gradientInfo['start'] as Alignment;
                    final gradientEnd = gradientInfo['end'] as Alignment;
                    final isAnimating = gradientInfo['isAnimating'] as bool;

                    // Get animated selection border info
                    final selectionBorderInfo = _getSelectionBorderInfo(
                        details.date,
                        selectedDate,
                        _currentSelectedDate != selectedDate
                            ? _currentSelectedDate
                            : null,
                        _selectionAnimation.value);

                    final borderWidth =
                        selectionBorderInfo['borderWidth'] as double;
                    final borderOpacity =
                        selectionBorderInfo['borderOpacity'] as double;
                    final scale = selectionBorderInfo['scale'] as double;

                    List<BookingModel> bookings = data.where((element) {
                      return isOverlapping(details.date, element.timeRange);
                    }).toList();
                    bool isBooked = bookings.isNotEmpty;

                    bool fullyBooked =
                        controller.isFullyBooked(details.date, bookings);

                    return AnimatedContainer(
                      duration: Duration(
                          milliseconds:
                              300), // Fixed duration for smooth transitions
                      curve: Curves.easeInOutCubic,
                      transform: Matrix4.identity()..scale(scale),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: borderWidth > 0
                            ? Border.all(
                                color: context.colors.secondary
                                    .withOpacity(borderOpacity),
                                width: borderWidth,
                              )
                            : Border.all(width: 0.2, color: Colors.grey),
                      ),
                      child: Stack(
                        children: [
                          // Animated directional gradient within each cell
                          if (intensity > 0)
                            AnimatedContainer(
                              duration: const Duration(
                                  milliseconds:
                                      400), // Fixed duration for smooth gradient transition
                              curve: Curves.easeInOutCubic,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: gradientStart,
                                  end: gradientEnd,
                                  colors: [
                                    Colors.transparent,
                                    context.colors.secondary
                                        .withOpacity(intensity * 0.3),
                                    context.colors.secondary
                                        .withOpacity(intensity * 0.6),
                                    context.colors.secondary
                                        .withOpacity(intensity),
                                  ],
                                  stops: const [0.0, 0.3, 0.7, 1.0],
                                ),
                              ),
                            ),
                          Column(
                            children: [
                              Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOutCubic,
                                  style: TextStyle(
                                    fontSize: borderWidth > 0 ? 16 : 14,
                                    fontWeight:
                                        intensity > 0.15 || borderWidth > 0
                                            ? FontWeight.w500
                                            : FontWeight.normal,
                                    color: !isCurrentMonth
                                        ? Colors.grey
                                        : borderWidth > 0
                                            ? context.colors.secondary
                                            : intensity > 0.15
                                                ? context.colors.secondary
                                                    .withOpacity(0.9)
                                                : Colors.white,
                                  ),
                                  child: AnimatedScale(
                                    scale: borderWidth > 0 ? 1.1 : 1.0,
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOutCubic,
                                    child: Text(details.date.day.toString()),
                                  ),
                                ),
                              ),
                              if (isBooked)
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: borderWidth > 0 ? 0 : 3),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOutCubic,
                                    child: CircleAvatar(
                                      radius: borderWidth > 0 ? 4 : 3,
                                      backgroundColor: fullyBooked
                                          ? Colors.green
                                          : Colors.red,
                                    ),
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
              loading: () => const Loader(),
            );
      },
    );
  }
}
