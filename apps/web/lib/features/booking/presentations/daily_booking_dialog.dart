import 'package:constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:util/util.dart';
import 'package:web/web.dart' as web;
import 'package:website/core/utility/new_tab.dart';
import 'package:website/features/auth/controller/auth_controller.dart';
import 'package:website/features/booking/controller/booking_controller.dart';

import '../../../core/widgets/loader.dart';

void _openInNewTab(String path) {
  if (kIsWeb) {
    web.window.open(path, '_blank');
  }
}

class DailyBookingDialog extends ConsumerStatefulWidget {
  const DailyBookingDialog({super.key});

  @override
  ConsumerState createState() => _DailyBookingDialogState();
}

class _DailyBookingDialogState extends ConsumerState<DailyBookingDialog> {
  late CalendarController _dailyCalendarController;
  int _appointmentCounter = 0;

  @override
  void initState() {
    super.initState();
    _dailyCalendarController = CalendarController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future(
      () {
        // Get the initial date from the provider
        final initialDate = ref.read(calendarDateNotifierProvider);
        if (initialDate != null) {
          _updateCalendarDate(initialDate);
        } else {
          // If no date is set, use today's date
          _updateCalendarDate(DateTime.now());
        }
      },
    );
    // Set the initial date after dependencies are available
  }

  void _updateCalendarDate(DateTime date) {
    print('Updating calendar to date: $date');

    // Set both display date and selected date
    _dailyCalendarController.displayDate = date;
    _dailyCalendarController.selectedDate = date;
  }

  // This helper method is now a static function or a top-level function
  // to prevent it from being tightly coupled to the widget's state.
  static AppointmentDataSource _getCalendarDataSource(
      List<BookingModel> bookingModels) {
    List<BookingModel> appointments = <BookingModel>[];

    for (BookingModel booking in bookingModels) {
      int duration =
          booking.timeRange.end.difference(booking.timeRange.start).inDays;

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

        appointments.add(BookingModel(
          timeRange: CustomDateTimeRange(
            start: startTime,
            end: endTime,
          ),
          description: booking.description,
          title: booking.title,
          recurrenceState: booking.recurrenceState,
          location: booking.location,
          createdAt: booking.createdAt,
          host: booking.host,
          userId: booking.userId,
          id: booking.id,
        ));
      }
    }
    return AppointmentDataSource(appointments);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    final bookingStream = ref.watch(bookingStreamProvider());
    final user = ref.watch(userProvider);

    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.all(10),
      content: SizedBox(
        width: ResponsiveValue(context, conditionalValues: [
          Condition.equals(name: MOBILE, value: width * 0.9),
          Condition.between(start: 450, end: 800, value: width * 0.8),
          Condition.between(start: 801, end: 1200, value: width * 0.6),
          Condition.between(start: 1201, end: 3000, value: 1000),
        ]).value.toDouble(),
        height: height * 0.85,
        child: GlassmorphicContainer(
          width: double.infinity,
          height: double.infinity,
          borderRadius: 20,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.2),
              Colors.white.withOpacity(0.1),
            ],
            stops: const [0.1, 1],
          ),
          border: 2,
          blur: 15,
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.5),
            ],
          ),
          child: Column(
            children: [
              // Header with title and close button
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Add date display to verify the correct date is being used

                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        color: context.colors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              // Calendar content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveValue(context, conditionalValues: [
                    Condition.equals(name: MOBILE, value: 16),
                    Condition.between(start: 450, end: 800, value: 20),
                    Condition.between(start: 801, end: 1200, value: 22),
                    Condition.between(start: 1201, end: 3000, value: 24),
                  ]).value.toDouble()),
                  child: bookingStream.when(
                    data: (data) {
                      final dataSource = _getCalendarDataSource(data);

                      // Reset the counter for each frame build
                      _appointmentCounter = 0;

                      return SfCalendar(
                        viewNavigationMode: ViewNavigationMode.none,
                        controller:
                            _dailyCalendarController, // Use the controller
                        // Remove initialSelectedDate - controller handles this
                        headerHeight:
                            ResponsiveValue(context, conditionalValues: [
                          Condition.smallerThan(name: MOBILE, value: 60),
                          Condition.between(start: 450, end: 800, value: 70),
                          Condition.largerThan(name: TABLET, value: 80),
                        ]).value.toDouble(),
                        viewHeaderHeight:
                            ResponsiveValue(context, conditionalValues: [
                          Condition.smallerThan(name: MOBILE, value: 50),
                          Condition.between(start: 450, end: 800, value: 60),
                          Condition.largerThan(name: TABLET, value: 70),
                        ]).value.toDouble(),
                        headerStyle: CalendarHeaderStyle(
                          textAlign: TextAlign.center,
                          backgroundColor: Colors.transparent,
                          textStyle: TextStyle(
                            fontSize:
                                ResponsiveValue(context, conditionalValues: [
                              Condition.smallerThan(name: MOBILE, value: 20),
                              Condition.between(
                                  start: 450, end: 800, value: 24),
                              Condition.largerThan(name: TABLET, value: 30),
                            ]).value.toDouble(),
                            fontWeight: FontWeight.w600,
                            color: context.colors.primary,
                          ),
                        ),
                        onViewChanged: (ViewChangedDetails details) {
                          // CRITICAL FIX: Don't update provider from daily dialog view changes
                          // This was causing the date to revert to today when dialog opened
                          print(
                              'Daily dialog view changed - NOT updating provider');

                          // Only log for debugging, don't update the provider
                          if (details.visibleDates.isNotEmpty) {
                            final visibleDate = details.visibleDates.first;
                            print('Daily dialog showing: $visibleDate');
                          }
                        },
                        onLongPress: (CalendarLongPressDetails tapped) {
                          // Your existing long press logic here
                        },
                        appointmentBuilder: (BuildContext context,
                            CalendarAppointmentDetails details) {
                          final appointment =
                              details.appointments.first as BookingModel;

                          // Use the counter to determine the alternating color
                          final backgroundColor = _appointmentCounter % 2 == 0
                              ? context.colors.primaryContainer.withOpacity(0.8)
                              : context.colors.secondaryContainer
                                  .withOpacity(0.8);

                          // Increment the counter for the next appointment
                          _appointmentCounter++;

                          return NewTabContextMenu(
                            url: '/#/booking/${appointment.id}',
                            child: GestureDetector(
                              onTap: () {
                                context.pop();
                                context.go(
                                  '/booking/${appointment.id}',
                                  extra: appointment,
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color:
                                        context.colors.primary.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        appointment.title,
                                        style: TextStyle(
                                          fontSize: ResponsiveValue(context,
                                              conditionalValues: [
                                                Condition.equals(
                                                    name: MOBILE, value: 14),
                                                Condition.between(
                                                    start: 450,
                                                    end: 800,
                                                    value: 18),
                                                Condition.between(
                                                    start: 801,
                                                    end: 1200,
                                                    value: 20),
                                                Condition.between(
                                                    start: 1201,
                                                    end: 3000,
                                                    value: 24),
                                              ]).value.toDouble(),
                                          fontWeight: FontWeight.w600,
                                          color: context.colors.primary,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (appointment.description.isNotEmpty)
                                        Text(
                                          appointment.description,
                                          style: TextStyle(
                                            fontSize: ResponsiveValue(context,
                                                conditionalValues: [
                                                  Condition.equals(
                                                      name: MOBILE, value: 12),
                                                  Condition.between(
                                                      start: 450,
                                                      end: 800,
                                                      value: 16),
                                                  Condition.between(
                                                      start: 801,
                                                      end: 1200,
                                                      value: 20),
                                                  Condition.between(
                                                      start: 1201,
                                                      end: 3000,
                                                      value: 24),
                                                ]).value.toDouble(),
                                            color: context.colors.secondary
                                                .withOpacity(0.8),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        dataSource: dataSource,
                        view: CalendarView.day,
                        timeSlotViewSettings: TimeSlotViewSettings(
                          timeRulerSize:
                              ResponsiveValue(context, conditionalValues: [
                            Condition.equals(name: MOBILE, value: 80),
                            Condition.between(start: 450, end: 800, value: 90),
                            Condition.between(
                                start: 801, end: 1200, value: 100),
                            Condition.between(
                                start: 1201, end: 3000, value: 120),
                          ]).value.toDouble(),
                          timeIntervalHeight:
                              ResponsiveValue(context, conditionalValues: [
                            Condition.equals(name: MOBILE, value: 80),
                            Condition.between(start: 450, end: 800, value: 100),
                            Condition.between(
                                start: 801, end: 1200, value: 110),
                            Condition.between(
                                start: 1201, end: 3000, value: 130),
                          ]).value.toDouble(),
                          timeFormat: 'hh:mm a',
                          timeInterval: const Duration(minutes: 30),
                          timeTextStyle: TextStyle(
                            color: context.colors.secondary,
                            fontSize:
                                ResponsiveValue(context, conditionalValues: [
                              Condition.equals(name: MOBILE, value: 12),
                              Condition.between(
                                  start: 450, end: 800, value: 16),
                              Condition.between(
                                  start: 801, end: 1200, value: 18),
                              Condition.between(
                                  start: 1201, end: 3000, value: 22),
                            ]).value.toDouble(),
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                      );
                    },
                    error: (error, stack) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: context.colors.error,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading calendar',
                              style: TextStyle(
                                fontSize: ResponsiveValue(context,
                                    conditionalValues: [
                                      Condition.equals(name: MOBILE, value: 18),
                                      Condition.between(
                                          start: 450, end: 800, value: 22),
                                      Condition.between(
                                          start: 801, end: 1200, value: 26),
                                      Condition.between(
                                          start: 1201, end: 3000, value: 28),
                                    ]).value.toDouble(),
                                color: context.colors.error,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () => const Center(child: Loader()),
                  ),
                ),
              ),

              // Footer with instructions
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '• Tap appointments to view details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: ResponsiveValue(context, conditionalValues: [
                      Condition.equals(name: MOBILE, value: 12),
                      Condition.between(start: 450, end: 800, value: 14),
                      Condition.between(start: 801, end: 1200, value: 16),
                      Condition.between(start: 1201, end: 3000, value: 20),
                    ]).value.toDouble(),
                    color: context.colors.secondary.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
