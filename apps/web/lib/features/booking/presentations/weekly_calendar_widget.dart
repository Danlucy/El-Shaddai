import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:website/core/widgets/loader.dart';
import 'package:website/features/booking/controller/data_source.dart';

import '../provider/booking_provider.dart';

class WeeklyCalendarComponent extends ConsumerStatefulWidget {
  const WeeklyCalendarComponent({required this.view, super.key});
  final CalendarView view;
  @override
  ConsumerState<WeeklyCalendarComponent> createState() =>
      _WebCalendarComponentState();
}

class _WebCalendarComponentState
    extends ConsumerState<WeeklyCalendarComponent> {
  late CalendarController _calendarController;
  bool _isUpdatingFromProvider = false;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();

    // Initial Sync
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedDate = ref.read(calendarDateNotifierProvider);
      _calendarController.displayDate = selectedDate;
      _calendarController.selectedDate = selectedDate;
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  // ✅ FIXED: Explicitly update displayDate to jump to the new week
  void _updateControllerFromProvider(DateTime date) {
    if (_isUpdatingFromProvider) return;

    _isUpdatingFromProvider = true;

    // 1. Force the view to jump to the specific week
    if (_calendarController.displayDate?.year != date.year ||
        _calendarController.displayDate?.month != date.month ||
        _calendarController.displayDate?.day != date.day) {
      _calendarController.displayDate = date;
    }

    // 2. Select the specific day
    if (_calendarController.selectedDate != date) {
      _calendarController.selectedDate = date;
    }

    // Small delay to prevent feedback loops
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _isUpdatingFromProvider = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Watch for UI rebuilds
    final selectedDate = ref.watch(calendarDateNotifierProvider);
    bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    // 2. Listen for logic updates (The Link)
    ref.listen(calendarDateNotifierProvider, (previous, next) {
      if (previous != next) {
        _updateControllerFromProvider(next);
      }
    });

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
                        headerHeight: 0,
                        view: widget.view,
                        controller: _calendarController,
                        dataSource: BookingDataSource(data),
                        initialSelectedDate: selectedDate,
                        initialDisplayDate: selectedDate, // Important for init

                        showDatePickerButton: true,
                        showNavigationArrow: true,
                        viewHeaderHeight: isDesktop ? 80 : 0,
                        timeSlotViewSettings: TimeSlotViewSettings(
                          timeTextStyle: TextStyle(
                            fontSize: isDesktop ? 14 : 18,
                            color: context.colors.secondary.withOpac(0.7),
                          ),
                          timeFormat: 'h a',
                          timelineAppointmentHeight: double.infinity,
                          dayFormat: 'EEE',
                          dateFormat: 'd',
                          timeIntervalWidth: isDesktop ? 60 : 80,
                          startHour: 0,
                          endHour: 24,
                          numberOfDaysInView: isDesktop ? 7 : 1,
                        ),

                        appointmentBuilder: (context, details) {
                          final dynamic data = details.appointments.first;
                          String subject = 'Booked';
                          if (data is BookingModel) {
                            subject = data.description;
                          }

                          final Color cardColor =
                              context.colors.secondaryContainer;

                          return Container(
                            width: details.bounds.width,
                            height: details.bounds.height,
                            decoration: BoxDecoration(
                              color: cardColor.withOpac(0.7),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: cardColor, width: 1),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              subject,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },

                        // Handle user interaction on the Weekly calendar
                        onSelectionChanged: (CalendarSelectionDetails details) {
                          if (details.date != null &&
                              !_isUpdatingFromProvider) {
                            Future.microtask(() {
                              ref
                                  .read(calendarDateNotifierProvider.notifier)
                                  .updateSelectedDate(details.date!);
                            });
                          }
                        },

                        onTap: (CalendarTapDetails details) {
                          // Navigate to details if appointment tapped
                          if (details.appointments != null &&
                              details.appointments!.isNotEmpty) {
                            final dynamic data = details.appointments!.first;
                            if (data is BookingModel) {
                              context.go('/booking/${data.id}');
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          error: (error, stack) => Center(child: Text('Error: $error')),
          loading: () => const Center(child: Loader()),
        );
  }
}
