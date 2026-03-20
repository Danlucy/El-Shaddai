import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile/features/booking/controller/booking_controller.dart';
import 'package:models/models.dart' hide UserModelX;
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:util/util.dart';

import '../../../core/widgets/loader.dart';
import '../../auth/controller/auth_controller.dart';
import '../../home/widgets/general_drawer.dart';
import '../provider/booking_provider.dart';
import 'booking_details_dialog.dart';
import 'booking_screen.dart';

class BookingListScreen extends ConsumerStatefulWidget {
  const BookingListScreen({super.key});

  @override
  ConsumerState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends ConsumerState<BookingListScreen> {
  Timer? _initialTimer;
  Timer? _periodicTimer;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    final now = DateTime.now();
    final delay = Duration(
      seconds: 60 - now.second,
      milliseconds: 1000 - now.millisecond,
    );

    _initialTimer = Timer(delay, () {
      if (mounted) {
        setState(() {});
        _periodicTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
          if (mounted) {
            setState(() {});
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _initialTimer?.cancel();
    _periodicTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final textScaleFactor = TextScaleFactor.scaleFactor(textScale);
    final today = DateTime.now();

    final user = ref.read(userProvider).value;
    double appointmentHeight = 70;

    if (textScaleFactor == TextScaleFactor.oldMan) {
      appointmentHeight = 110;
    } else if (textScaleFactor == TextScaleFactor.boomer) {
      appointmentHeight = 90;
    }

    final filteredBookingsAsync = ref.watch(filteredBookingListsProvider);
    final searchQuery = ref.watch(bookingListSearchQueryProvider);
    final controllerFunction = ref.watch(bookingControllerProvider.notifier);
    return Scaffold(
      drawer: const GeneralDrawer(),
      appBar: AppBar(title: const Text('Prayer Watch List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) =>
                  ref.read(bookingListSearchQueryProvider.notifier).update(val),
              decoration: InputDecoration(
                hintText: 'Search Prayer Watch or Host',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          FocusScope.of(context).unfocus();
                          ref
                              .read(bookingListSearchQueryProvider.notifier)
                              .update('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: filteredBookingsAsync.when(
              data: (data) {
                return SfCalendar(
                  showNavigationArrow: true,
                  view: CalendarView.schedule,
                  scheduleViewSettings: ScheduleViewSettings(
                    dayHeaderSettings: const DayHeaderSettings(width: 60),
                    appointmentItemHeight: appointmentHeight,
                    monthHeaderSettings: const MonthHeaderSettings(height: 80),
                    hideEmptyScheduleWeek: true,
                  ),
                  showDatePickerButton: true,
                  appointmentBuilder:
                      (
                        BuildContext context,
                        CalendarAppointmentDetails details,
                      ) {
                        BookingModel bookingModel = details.appointments.first;

                        final appointmentDate = details.date;
                        final currentTime = DateTime.now();

                        final isUpcomingAppointment =
                            currentTime.isAfter(
                              bookingModel.timeRange.start.subtract(
                                const Duration(minutes: 10),
                              ),
                            ) &&
                            currentTime.isBefore(bookingModel.timeRange.start);

                        final isLiveAppointment =
                            currentTime.isAfter(bookingModel.timeRange.start) &&
                            currentTime.isBefore(bookingModel.timeRange.end);

                        final isPastAppointment = appointmentDate.isBefore(
                          DateTime(today.year, today.month, today.day),
                        );

                        final appointmentColor = isUpcomingAppointment
                            ? context.colors.onTertiaryFixedVariant
                            : isPastAppointment
                            ? Theme.of(
                                context,
                              ).colorScheme.secondaryContainer.withOpac(0.5)
                            : Theme.of(context).colorScheme.secondaryContainer;

                        return GestureDetector(
                          onLongPress: () {
                            if (bookingModel.userId != user?.uid &&
                                user?.currentRole(ref) != UserRole.admin) {
                              return;
                            }
                            controllerFunction.deleteBooking(
                              context,
                              bookingModel,
                            );
                          },
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => BookingDetailsDialog(
                                bookingModel: bookingModel,
                              ),
                            );
                          },
                          child: isLiveAppointment
                              ? _LiveAppointmentCard(bookingModel: bookingModel)
                              : isUpcomingAppointment
                              ? _UpcomingAppointmentCard(
                                  bookingModel: bookingModel,
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: appointmentColor,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: _AppointmentContent(
                                    bookingModel: bookingModel,
                                  ),
                                ),
                        );
                      },
                  dataSource: _getCalendarDataSource(data),
                  scheduleViewMonthHeaderBuilder:
                      (
                        BuildContext buildContext,
                        ScheduleViewMonthHeaderDetails details,
                      ) {
                        return Container(
                          color: Theme.of(context).colorScheme.onPrimary,
                          child: Center(
                            child: AutoSizeText(
                              maxFontSize: 24,
                              minFontSize: 16,
                              DateFormat('MMMM yyyy').format(details.date),
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.inverseSurface,
                              ),
                            ),
                          ),
                        );
                      },
                );
              },
              error: (error, stack) => const Center(child: Text('Error')),
              loading: () => const Loader(),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Upcoming appointment card — amber glow + live countdown timer
// ---------------------------------------------------------------------------
class _UpcomingAppointmentCard extends StatefulWidget {
  const _UpcomingAppointmentCard({required this.bookingModel});

  final BookingModel bookingModel;

  @override
  State<_UpcomingAppointmentCard> createState() =>
      _UpcomingAppointmentCardState();
}

class _UpcomingAppointmentCardState extends State<_UpcomingAppointmentCard> {
  late Timer _countdownTimer;
  late Duration _remaining;

  static const _upcomingAmber = Color(0xFFFF9500);

  @override
  void initState() {
    super.initState();
    _remaining = widget.bookingModel.timeRange.start.difference(DateTime.now());
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final remaining = widget.bookingModel.timeRange.start.difference(
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
        decoration: BoxDecoration(
          color: context.colors.secondaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(
            color: _upcomingAmber.withOpacity(0.55),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _upcomingAmber.withOpacity(0.25),
              blurRadius: 1,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            _AppointmentContent(bookingModel: widget.bookingModel),
            Positioned(
              bottom: 4,
              right: 6,
              child: _CountdownBadge(
                countdownText: _countdownText,
                color: _upcomingAmber,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountdownBadge extends StatelessWidget {
  const _CountdownBadge({required this.countdownText, required this.color});

  final String countdownText;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Pulsing clock icon
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
          child: Icon(Icons.timer_outlined, size: 10, color: color),
        ),
        const SizedBox(width: 3),
        Text(
          countdownText,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Live appointment card — glowing red border + pulsing scale + LIVE badge
// ---------------------------------------------------------------------------
class _LiveAppointmentCard extends StatelessWidget {
  const _LiveAppointmentCard({required this.bookingModel});

  final BookingModel bookingModel;

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
        decoration: BoxDecoration(
          color: context.colors.secondaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: _liveRed.withOpacity(0.6), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: _liveRed.withOpacity(0.6),
              blurRadius: 1,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            _AppointmentContent(bookingModel: bookingModel),
            const Positioned(bottom: 4, right: 6, child: _LiveBadge()),
          ],
        ),
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  static const _liveRed = Color(0xFFFF3B30);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Pulsing dot
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
            decoration: const BoxDecoration(shape: BoxShape.circle),
          ),
        ),
        const SizedBox(width: 4),
        // Shimmering LIVE text
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
// Shared appointment content (title, host, time range)
// ---------------------------------------------------------------------------
class _AppointmentContent extends StatelessWidget {
  const _AppointmentContent({required this.bookingModel});

  final BookingModel bookingModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            maxLines: 1,
            maxFontSize: 16,
            minFontSize: 12,
            overflow: TextOverflow.ellipsis,
            bookingModel.title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          AutoSizeText(
            bookingModel.host,
            maxFontSize: 12,
            minFontSize: 8,
            style: const TextStyle(color: Colors.grey),
          ),
          Row(
            children: [
              AutoSizeText(
                maxFontSize: 14,
                minFontSize: 10,
                DateFormat('hh:mm a').format(bookingModel.timeRange.start),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const Icon(Icons.arrow_right_alt),
              AutoSizeText(
                maxFontSize: 14,
                minFontSize: 10,
                DateFormat('hh:mm a').format(bookingModel.timeRange.end),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Calendar data source
// ---------------------------------------------------------------------------
_AppointmentDataSource _getCalendarDataSource(List<BookingModel> bookingModel) {
  List<BookingModel> appointments = <BookingModel>[];
  for (BookingModel booking in bookingModel) {
    int duration = booking.timeRange.end.day - booking.timeRange.start.day;
    for (int i = 0; i < duration + 1; i++) {
      DateTime appointmentDate = booking.timeRange.start.add(Duration(days: i));

      DateTime currentStartTime = (i == 0)
          ? booking.timeRange.start
          : DateTime(
              appointmentDate.year,
              appointmentDate.month,
              appointmentDate.day,
              0,
              0,
            );

      DateTime currentEndTime = (i == duration)
          ? booking.timeRange.end
          : DateTime(
              appointmentDate.year,
              appointmentDate.month,
              appointmentDate.day,
              23,
              59,
            );

      appointments.add(
        BookingModel(
          timeRange: CustomDateTimeRange(
            start: currentStartTime,
            end: currentEndTime,
          ),
          description: booking.description,
          title: booking.title,
          groupId: booking.groupId,
          password: booking.password,
          recurrenceState: booking.recurrenceState,
          location: booking.location,
          createdAt: booking.createdAt,
          host: booking.host,
          userId: booking.userId,
          id: booking.id,
          occurrenceId: booking.occurrenceId,
          recurrenceModel: booking.recurrenceModel,
        ),
      );
    }
  }

  return _AppointmentDataSource(appointments);
}

class _AppointmentDataSource extends CalendarDataSource<BookingModel> {
  _AppointmentDataSource(List<BookingModel> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) => appointments![index].timeRange.start;

  @override
  DateTime getEndTime(int index) => appointments![index].timeRange.end;

  @override
  String getDescription(int index) => appointments![index].description;

  @override
  String getTitle(int index) => appointments![index].title;

  @override
  BookingModel convertAppointmentToObject(
    BookingModel customData,
    Appointment appointment,
  ) {
    return customData;
  }
}
