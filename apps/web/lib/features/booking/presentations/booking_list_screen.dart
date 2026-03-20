import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    final filteredBookingsAsync = ref.watch(filteredBookingListsProvider);
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
                  child: filteredBookingsAsync.when(
                    data: (bookings) {
                      if (selectedBookingId == null && bookings.isNotEmpty) {
                        Future.microtask(
                          () => ref
                              .read(selectedBookingIDNotifierProvider.notifier)
                              .updateID(bookings.first.id),
                        );
                      }

                      BookingModel? selectedBooking;
                      try {
                        selectedBooking = bookings.firstWhere(
                          (b) => b.id == selectedBookingId,
                        );
                      } catch (e) {
                        selectedBooking = bookings.isNotEmpty
                            ? bookings.first
                            : null;
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

// ---------------------------------------------------------------------------
// Booking List
// ---------------------------------------------------------------------------
class _BookingList extends ConsumerStatefulWidget {
  const _BookingList({required this.bookings});
  final List<BookingModel> bookings;

  @override
  ConsumerState<_BookingList> createState() => _BookingListState();
}

class _BookingListState extends ConsumerState<_BookingList> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final selectedBookingId = ref.watch(selectedBookingIDNotifierProvider);
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final searchQuery = ref.watch(bookingListSearchQueryProvider);

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
        TextField(
          controller: _searchController,
          onChanged: (val) =>
              ref.read(bookingListSearchQueryProvider.notifier).update(val),
          decoration: InputDecoration(
            hintText: 'Search Prayer Watch or Host ..',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface.withOpac(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpac(0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpac(0.2),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 16,
            ),
            suffixIcon: searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      ref
                          .read(bookingListSearchQueryProvider.notifier)
                          .update('');
                      FocusScope.of(context).unfocus();
                    },
                  )
                : null,
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
                    constraints: const BoxConstraints(maxHeight: 50),
                    borderRadius: 20,
                    alignment: Alignment.center,
                    blur: 10,
                    border: 2,
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
                        DateFormat('MMMM yyyy').format(details.date),
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
            dataSource: getCalendarDataSource(widget.bookings),
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

                  final Color baseColor = isPast
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
                    child: isLive
                        ? _WebLiveAppointmentCard(
                            booking: booking,
                            isSelected: isSelected,
                            isDesktop: isDesktop,
                          )
                        : isUpcoming
                        ? _WebUpcomingAppointmentCard(
                            booking: booking,
                            isSelected: isSelected,
                            isDesktop: isDesktop,
                          )
                        : Material(
                            elevation: isSelected && isDesktop ? 8 : 2,
                            color: Colors.transparent,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpac(
                                      (isSelected && isDesktop) ? 0.4 : 0.15,
                                    ),
                                    spreadRadius: 1,
                                    blurRadius: 7,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                color: baseColor,
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected
                                    ? Border.all(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        width: 2,
                                      )
                                    : null,
                              ),
                              child: _AppointmentTileContent(booking: booking),
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

// ---------------------------------------------------------------------------
// Live card — red glow border, pulsing scale, LIVE badge
// ---------------------------------------------------------------------------
class _WebLiveAppointmentCard extends StatelessWidget {
  const _WebLiveAppointmentCard({
    required this.booking,
    required this.isSelected,
    required this.isDesktop,
  });

  final BookingModel booking;
  final bool isSelected;
  final bool isDesktop;

  static const _liveRed = Color(0xFFFF3B30);

  @override
  Widget build(BuildContext context) {
    return Animate(
      onPlay: (controller) => controller.repeat(reverse: true),
      effects: [
        ScaleEffect(
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.012, 1.012),
          duration: 1000.ms,
          curve: Curves.easeInOut,
        ),
      ],
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : _liveRed.withOpac(0.7),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _liveRed.withOpac(0.4),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            _AppointmentTileContent(booking: booking),
            const Positioned(bottom: 0, right: 0, child: _WebLiveBadge()),
          ],
        ),
      ),
    );
  }
}

class _WebLiveBadge extends StatelessWidget {
  const _WebLiveBadge();

  static const _liveRed = Color(0xFFFF3B30);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Animate(
          onPlay: (controller) => controller.repeat(reverse: true),
          effects: [
            FadeEffect(
              begin: 1.0,
              end: 0.2,
              duration: 700.ms,
              curve: Curves.easeInOut,
            ),
            ScaleEffect(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.5, 1.5),
              duration: 700.ms,
              curve: Curves.easeInOut,
            ),
          ],
          child: Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: _liveRed,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Animate(
          onPlay: (controller) => controller.repeat(),
          effects: [
            ShimmerEffect(
              color: Colors.white.withOpac(0.85),
              duration: 1800.ms,
              delay: 400.ms,
            ),
          ],
          child: const Text(
            'LIVE',
            style: TextStyle(
              color: _liveRed,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Upcoming card — amber glow border + live countdown timer
// ---------------------------------------------------------------------------
class _WebUpcomingAppointmentCard extends StatefulWidget {
  const _WebUpcomingAppointmentCard({
    required this.booking,
    required this.isSelected,
    required this.isDesktop,
  });

  final BookingModel booking;
  final bool isSelected;
  final bool isDesktop;

  @override
  State<_WebUpcomingAppointmentCard> createState() =>
      _WebUpcomingAppointmentCardState();
}

class _WebUpcomingAppointmentCardState
    extends State<_WebUpcomingAppointmentCard> {
  late Timer _countdownTimer;
  late Duration _remaining;

  static const _amber = Color(0xFFFF9500);

  @override
  void initState() {
    super.initState();
    _remaining = widget.booking.timeRange.start.difference(DateTime.now());
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final remaining = widget.booking.timeRange.start.difference(
        DateTime.now(),
      );
      setState(() {
        _remaining = remaining.isNegative ? Duration.zero : remaining;
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  String get _countdownText {
    if (_remaining.isNegative || _remaining == Duration.zero) return '0:00';
    final minutes = _remaining.inMinutes.remainder(60).toString();
    final seconds = _remaining.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      onPlay: (controller) => controller.repeat(reverse: true),
      effects: [
        ScaleEffect(
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.008, 1.008),
          duration: 1200.ms,
          curve: Curves.easeInOut,
        ),
      ],
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.isSelected
                ? Theme.of(context).colorScheme.primary
                : _amber.withOpac(0.55),
            width: widget.isSelected ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _amber.withOpac(0.35),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            _AppointmentTileContent(booking: widget.booking),
            Positioned(
              bottom: 0,
              right: 0,
              child: _WebCountdownBadge(countdownText: _countdownText),
            ),
          ],
        ),
      ),
    );
  }
}

class _WebCountdownBadge extends StatelessWidget {
  const _WebCountdownBadge({required this.countdownText});

  final String countdownText;

  static const _amber = Color(0xFFFF9500);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Animate(
          onPlay: (controller) => controller.repeat(reverse: true),
          effects: [
            FadeEffect(
              begin: 1.0,
              end: 0.4,
              duration: 800.ms,
              curve: Curves.easeInOut,
            ),
          ],
          child: const Icon(Icons.timer_outlined, size: 10, color: _amber),
        ),
        const SizedBox(width: 3),
        Text(
          countdownText,
          style: const TextStyle(
            color: _amber,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared tile content
// ---------------------------------------------------------------------------
class _AppointmentTileContent extends StatelessWidget {
  const _AppointmentTileContent({required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AutoSizeText(
          booking.title,
          maxLines: 1,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          '${DateFormat.jm().format(booking.timeRange.start)} - ${DateFormat.jm().format(booking.timeRange.end)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
