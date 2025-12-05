import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:models/models.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:website/core/widgets/animated_background.dart';
import 'package:website/core/widgets/loader.dart';
import 'package:website/features/booking/controller/booking_controller.dart';
import 'package:website/features/booking/controller/data_source.dart';
import 'package:website/features/booking/provider/booking_provider.dart';
import 'package:website/features/booking/widget/booking_details_widget.dart';

// Provider to hold the currently selected booking ID

class BookingListScreen extends ConsumerStatefulWidget {
  const BookingListScreen({super.key});

  @override
  ConsumerState<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends ConsumerState<BookingListScreen> {
  Timer? _initialTimer;
  Timer? _periodicTimer;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final delay = Duration(
      seconds: 60 - now.second,
      milliseconds: 1000 - now.millisecond,
    );

    _initialTimer = Timer(delay, () {
      if (mounted) {
        setState(() {});
        _periodicTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
          if (mounted) setState(() {});
        });
      }
    });
  }

  @override
  void dispose() {
    _initialTimer?.cancel();
    _periodicTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingStream = ref.watch(getCurrentOrgBookingsStreamProvider);
    final selectedBookingId = ref.watch(selectedBookingIDNotifierProvider);
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnimatedBackground(
        surfaceColor: Theme.of(context).colorScheme.surface,
        secondaryColor: Theme.of(context).colorScheme.secondary,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: GlassmorphicContainer(
                width: 1400,
                height: MediaQuery.sizeOf(context).height * 0.85,
                borderRadius: 20,
                blur: 15,
                border: 2,
                linearGradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.surface.withOpac(0.1),
                    Theme.of(context).colorScheme.surface.withOpac(0.05),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderGradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Theme.of(context).colorScheme.onSurface.withOpac(0.2),
                    Theme.of(context).colorScheme.onSurface.withOpac(0.2),
                    Colors.transparent,
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: bookingStream.when(
                    data: (bookings) {
                      // Automatically select the first booking if none is selected
                      if (selectedBookingId == null && bookings.isNotEmpty) {
                        Future.microtask(
                          () => ref
                              .read(selectedBookingIDNotifierProvider.notifier)
                              .updateID(bookings.first.id),
                        );
                      }

                      BookingModel? selectedBooking;
                      if (selectedBookingId != null) {
                        try {
                          selectedBooking = bookings.firstWhere(
                            (b) => b.id == selectedBookingId,
                          );
                        } catch (e) {
                          selectedBooking = bookings.isNotEmpty
                              ? bookings.first
                              : null;
                        }
                      } else if (bookings.isNotEmpty) {
                        selectedBooking = bookings.first;
                      }

                      if (isDesktop) {
                        return ResponsiveRowColumn(
                          layout: ResponsiveRowColumnType.ROW,
                          rowCrossAxisAlignment: CrossAxisAlignment.start,
                          rowSpacing: 24,
                          children: [
                            ResponsiveRowColumnItem(
                              rowFlex: 1,
                              child: _BookingList(bookings: bookings),
                            ),
                            // Right Column: Booking Details
                            ResponsiveRowColumnItem(
                              rowFlex: 2,
                              child: selectedBooking != null
                                  ? BookingDetailsContent(
                                      booking: selectedBooking,
                                    )
                                  : const Center(
                                      child: Text(
                                        'Select a booking to see details.',
                                      ),
                                    ),
                            ),
                          ],
                        );
                      } else {
                        // On mobile, only show the list
                        return _BookingList(bookings: bookings);
                      }
                    },
                    loading: () => const Center(child: Loader()),
                    error: (e, s) =>
                        const Center(child: Text('Error loading bookings.')),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ✅ This widget now uses SfCalendar for a better UI.
class _BookingList extends ConsumerWidget {
  const _BookingList({required this.bookings});
  final List<BookingModel> bookings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();
    final selectedBookingId = ref.watch(selectedBookingIDNotifierProvider);
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prayer Watch List',
          style: TextStyle(
            fontSize: ResponsiveValue<double>(
              context,
              defaultValue: 16,
              conditionalValues: [
                Condition.between(start: 0, end: 450, value: 16),
                const Condition.between(start: 801, end: 1000, value: 20),
                const Condition.between(start: 1001, end: 1200, value: 22),
                const Condition.between(start: 1201, end: 1920, value: 24),
                const Condition.between(start: 1921, end: 3000, value: 26),
              ],
            ).value,
            fontWeight: FontWeight.bold,
            color: context.colors.primary,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SfCalendar(
            scheduleViewMonthHeaderBuilder:
                (BuildContext context, ScheduleViewMonthHeaderDetails details) {
                  return GlassmorphicContainer(
                    width: double.infinity,
                    height: double.infinity,
                    constraints: BoxConstraints(maxHeight: 50),

                    borderRadius: 20,
                    alignment: Alignment.center,
                    blur: 10,

                    border: 2,
                    // 🔥 your original gradients unchanged
                    linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpac(0.2),
                        Colors.white.withOpac(0.05),
                      ],
                      stops: const [0.1, 1],
                    ),
                    borderGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpac(0.5),
                        Colors.white.withOpac(0.5),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    child: Center(
                      child: Text(
                        DateFormat(
                          'MMMM yyyy',
                        ).format(details.date), // e.g. "August 2025"
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                      ),
                    ),
                  );
                },
            view: CalendarView.schedule,
            dataSource: getCalendarDataSource(bookings),
            scheduleViewSettings: ScheduleViewSettings(
              monthHeaderSettings: MonthHeaderSettings(
                height: ResponsiveValue<double>(
                  context,
                  defaultValue: 80,
                  conditionalValues: [
                    Condition.between(start: 0, end: 450, value: 80),
                    const Condition.between(start: 801, end: 1000, value: 80),
                    const Condition.between(start: 1001, end: 1200, value: 100),
                    const Condition.between(start: 1201, end: 1920, value: 100),
                    const Condition.between(start: 1921, end: 3000, value: 100),
                  ],
                ).value,
              ),
              appointmentItemHeight: ResponsiveValue<double>(
                context,
                defaultValue: 80,
                conditionalValues: [
                  Condition.between(start: 0, end: 450, value: 80),
                  const Condition.between(start: 801, end: 1000, value: 90),
                  const Condition.between(start: 1001, end: 1200, value: 90),
                  const Condition.between(start: 1201, end: 1920, value: 100),
                  const Condition.between(start: 1921, end: 3000, value: 100),
                ],
              ).value,
              hideEmptyScheduleWeek: true,
            ),
            appointmentBuilder:
                (BuildContext context, CalendarAppointmentDetails details) {
                  final booking = details.appointments.first as BookingModel;
                  final currentTime = DateTime.now();
                  final isUpcoming =
                      currentTime.isAfter(
                        booking.timeRange.start.subtract(
                          const Duration(minutes: 10),
                        ),
                      ) &&
                      currentTime.isBefore(booking.timeRange.start);
                  final isLive =
                      currentTime.isAfter(booking.timeRange.start) &&
                      currentTime.isBefore(booking.timeRange.end);
                  final isPast = details.date.isBefore(
                    DateTime(today.year, today.month, today.day),
                  );
                  final isSelected = booking.id == selectedBookingId;

                  final Color color = isLive
                      ? Theme.of(
                          context,
                        ).colorScheme.errorContainer.withOpac(0.4)
                      : isUpcoming
                      ? Theme.of(context).colorScheme.tertiaryContainer
                      : isPast
                      ? Theme.of(
                          context,
                        ).colorScheme.secondaryContainer.withOpac(0.5)
                      : context.colors.secondaryContainer;

                  return GestureDetector(
                    onTap: () {
                      if (isDesktop) {
                        ref
                            .read(selectedBookingIDNotifierProvider.notifier)
                            .updateID(booking.id);
                      } else {
                        context.go('/booking/${booking.id}');
                      }
                    },
                    child: Material(
                      elevation: isSelected && isDesktop ? 8 : 2,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpac(
                                (isSelected && isDesktop) ? 0.4 : 0.15,
                              ), // Light color for the glow
                              spreadRadius:
                                  1, // How much the box shadow expands
                              blurRadius: 7, // How diffused the shadow is
                              offset: const Offset(
                                0,
                                4,
                              ), // Shadow position (x, y) - slightly below
                            ),
                          ],
                          color: color,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              booking.title,
                              maxLines: 1,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${DateFormat.jm().format(booking.timeRange.start)} - ${DateFormat.jm().format(booking.timeRange.end)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
          ),
        ),
      ],
    );
  }
}
