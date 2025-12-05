import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:util/util.dart';
import 'package:website/core/widgets/loader.dart';
import 'package:website/features/booking/controller/booking_controller.dart';
import 'package:website/features/booking/controller/data_source.dart';
import 'package:website/features/booking/presentations/daily_booking_dialog.dart';

// Import the controller

import '../provider/booking_provider.dart';

class MonthlyCalendarComponent extends ConsumerStatefulWidget {
  const MonthlyCalendarComponent({super.key});

  @override
  ConsumerState<MonthlyCalendarComponent> createState() =>
      _WebCalendarComponentState();
}

class _WebCalendarComponentState extends ConsumerState<MonthlyCalendarComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController _gradientAnimationController;
  late Animation<double> _gradientAnimation;
  late CalendarController _calendarController;

  // Instance of the controller
  late MonthlyCalendarController _logicController;

  // Track the last known date to avoid redundant animations
  DateTime? _previousSelectedDate;
  // Flag to prevent infinite loops (Provider -> Controller -> Provider)
  bool _isUpdatingFromProvider = false;

  @override
  void initState() {
    super.initState();

    _logicController = MonthlyCalendarController();

    _gradientAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _gradientAnimation = CurvedAnimation(
      parent: _gradientAnimationController,
      curve: Curves.easeInOutCubic,
    );

    _gradientAnimationController.value = 1.0;
    _calendarController = CalendarController();

    // Initial Sync on Load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedDate = ref.read(calendarDateNotifierProvider);
      _calendarController.selectedDate = selectedDate;
      _calendarController.displayDate = selectedDate;
      _previousSelectedDate = selectedDate;
    });
  }

  @override
  void dispose() {
    _gradientAnimationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  // Centralized Logic: Updates Controller without triggering feedback loop
  void _updateControllerFromProvider(DateTime date) {
    if (_isUpdatingFromProvider) return; // Stop if we are already updating

    _isUpdatingFromProvider = true;

    // Trigger animation if date changed
    if (_previousSelectedDate != date) {
      _previousSelectedDate = date;
      _gradientAnimationController.reset();
      _gradientAnimationController.forward();
    }

    // Update Controller
    if (_calendarController.selectedDate != date) {
      _calendarController.selectedDate = date;
    }
    // Ensure the month view actually navigates to the new date
    if (_calendarController.displayDate?.month != date.month ||
        _calendarController.displayDate?.year != date.year) {
      _calendarController.displayDate = date;
    }

    // Release lock after a short delay
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _isUpdatingFromProvider = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. WATCH for UI Rebuilds
    final selectedDate = ref.watch(calendarDateNotifierProvider);

    // 2. LISTEN for Logic Updates
    ref.listen(calendarDateNotifierProvider, (previous, next) {
      if (previous != next) {
        _updateControllerFromProvider(next);
      }
    });

    final bool isLargeText = ResponsiveValue(
      context,
      defaultValue: false,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: false),
        Condition.between(start: 450, end: 800, value: true),
        Condition.largerThan(name: TABLET, value: true),
      ],
    ).value;
    return AnimatedBuilder(
      animation: _gradientAnimation,
      builder: (context, child) {
        return ref
            .watch(getCurrentOrgBookingsStreamProvider)
            .when(
              data: (data) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.withOpac(0.3),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SfCalendar(
                            view: CalendarView.month,
                            controller: _calendarController,
                            dataSource: BookingDataSource(data),
                            initialSelectedDate: selectedDate,

                            // Header Config
                            headerStyle: CalendarHeaderStyle(
                              textStyle: TextStyle(
                                fontSize: isLargeText ? 24 : 20,
                              ),
                              backgroundColor: Colors.transparent,
                            ),
                            headerHeight: ResponsiveValue(
                              context,
                              defaultValue: 50,
                              conditionalValues: [
                                Condition.between(
                                  start: 450,
                                  end: 800,
                                  value: 70,
                                ),
                                Condition.largerThan(name: TABLET, value: 80),
                              ],
                            ).value.toDouble(),

                            viewNavigationMode: ViewNavigationMode.none,
                            showNavigationArrow: true,

                            monthViewSettings: const MonthViewSettings(
                              appointmentDisplayCount: 0,
                            ),

                            // Selection Logic
                            onSelectionChanged:
                                (CalendarSelectionDetails details) {
                                  if (details.date != null &&
                                      !_isUpdatingFromProvider) {
                                    Future.microtask(() {
                                      final normalizedDate = DateTime(
                                        details.date!.year,
                                        details.date!.month,
                                        details.date!.day,
                                      );
                                      ref
                                          .read(
                                            calendarDateNotifierProvider
                                                .notifier,
                                          )
                                          .updateSelectedDate(normalizedDate);
                                    });
                                  }
                                },

                            // Cell Builder
                            monthCellBuilder:
                                (
                                  BuildContext context,
                                  MonthCellDetails details,
                                ) {
                                  // Get current display date from calendar controller or fallback to selected
                                  final currentDisplayDate =
                                      _calendarController.displayDate ??
                                      selectedDate;

                                  bool isCurrentMonth =
                                      details.date.month ==
                                      currentDisplayDate.month;

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

                                  bool isSelectedDate =
                                      normalizedDetailDate ==
                                      normalizedSelectedDate;

                                  // DELEGATED TO CONTROLLER
                                  final gradientInfo = _logicController
                                      .getCellGradientInfo(
                                        date: details.date,
                                        selectedDate: selectedDate,
                                        previousSelectedDate:
                                            _previousSelectedDate,
                                        currentDisplayDate: currentDisplayDate,
                                        animationValue:
                                            _gradientAnimation.value,
                                      );

                                  final intensity =
                                      gradientInfo['intensity'] as double;
                                  final gradientStart =
                                      gradientInfo['start'] as Alignment;
                                  final gradientEnd =
                                      gradientInfo['end'] as Alignment;

                                  // Filter bookings for this day
                                  List<BookingModel> bookings = data.where((
                                    element,
                                  ) {
                                    return isOverlapping(
                                      details.date,
                                      element.timeRange,
                                    );
                                  }).toList();

                                  bool isBooked = bookings.isNotEmpty;

                                  // DELEGATED TO CONTROLLER
                                  bool fullyBooked = _logicController
                                      .isFullyBooked(details.date, bookings);

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
                                                color: Colors.grey.withOpac(
                                                  0.4,
                                                ),
                                              ),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          final normalizedDate = DateTime(
                                            details.date.year,
                                            details.date.month,
                                            details.date.day,
                                          );

                                          Future.microtask(() {
                                            ref
                                                .read(
                                                  calendarDateNotifierProvider
                                                      .notifier,
                                                )
                                                .updateSelectedDate(
                                                  normalizedDate,
                                                );

                                            if (selectedDate ==
                                                normalizedDate) {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    const DailyBookingDialog(),
                                              );
                                            }
                                          });
                                        },
                                        child: Center(
                                          child: Stack(
                                            children: [
                                              if (intensity > 0)
                                                _MonthCalendarCellShadowDecoration(
                                                  gradientStart,
                                                  gradientEnd,
                                                  context,
                                                  intensity,
                                                ),
                                              Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    4.0,
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        details.date.day
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize:
                                                              isSelectedDate
                                                              ? (isLargeText
                                                                    ? 22
                                                                    : 18)
                                                              : (isLargeText
                                                                    ? 20
                                                                    : 16),
                                                          fontWeight:
                                                              intensity >
                                                                      0.15 ||
                                                                  isSelectedDate
                                                              ? FontWeight.w600
                                                              : FontWeight
                                                                    .normal,
                                                          color: !isCurrentMonth
                                                              ? Colors.grey
                                                                    .withOpac(
                                                                      0.6,
                                                                    )
                                                              : isSelectedDate
                                                              ? context
                                                                    .colors
                                                                    .secondary
                                                              : intensity > 0.15
                                                              ? context
                                                                    .colors
                                                                    .secondary
                                                                    .withOpac(
                                                                      0.9,
                                                                    )
                                                              : Colors.white,
                                                        ),
                                                      ),
                                                      if (isBooked) ...[
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        CircleAvatar(
                                                          radius: isSelectedDate
                                                              ? 4.5
                                                              : 3.5,
                                                          backgroundColor:
                                                              fullyBooked
                                                              ? Colors.red
                                                                    .withOpac(
                                                                      0.9,
                                                                    )
                                                              : Colors.green
                                                                    .withOpac(
                                                                      0.9,
                                                                    ),
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
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              error: (error, stack) => const Center(
                child: Text(
                  'Error loading calendar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              loading: () => const Center(child: Loader()),
            );
      },
    );
  }

  Container _MonthCalendarCellShadowDecoration(
    Alignment gradientStart,
    Alignment gradientEnd,
    BuildContext context,
    double intensity,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: gradientStart,
          end: gradientEnd,
          colors: [
            Colors.transparent,
            context.colors.secondary.withOpac(intensity * 0.25),
            context.colors.secondary.withOpac(intensity * 0.5),
            context.colors.secondary.withOpac(intensity * 0.8),
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
      ),
    );
  }
}
