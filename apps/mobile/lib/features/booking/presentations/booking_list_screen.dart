import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:models/models.dart' hide UserModelX;
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:util/util.dart';

import '../../../core/widgets/loader.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/widgets/confirm_button.dart';
import '../../calendar/widget/booking_details_dialog.dart';
import '../../home/widgets/general_drawer.dart';
import '../provider/booking_provider.dart';
import 'booking_screen.dart';

class BookingListScreen extends ConsumerStatefulWidget {
  const BookingListScreen({super.key});

  @override
  ConsumerState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends ConsumerState<BookingListScreen> {
  Timer? _initialTimer;
  Timer? _periodicTimer;

  // 1. Declare the controller
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();

    // 2. Initialize the controller
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
    // 3. Dispose the controller to free resources
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

    // Watch the filtered bookings and search query
    final filteredBookingsAsync = ref.watch(filteredBookingListsProvider);
    final searchQuery = ref.watch(bookingListSearchQueryProvider);

    return Scaffold(
      drawer: const GeneralDrawer(),
      appBar: AppBar(title: const Text('Prayer Watch List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              // 4. Attach the controller here
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
                          // 5. Clear both the text field UI and the Riverpod state
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

                        final appointmentColor = isLiveAppointment
                            ? context.colors.errorContainer.withOpac(0.4)
                            : isUpcomingAppointment
                            ? context.colors.tertiary
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
                            showDialog(
                              context: context,
                              builder: (context) {
                                return ConfirmButton(
                                  confirmText: 'Delete ',
                                  cancelText: 'Cancel',
                                  description:
                                      'Are you sure you want to delete this booking? This action cannot be reversed',
                                  confirmAction: () {
                                    context.pop();
                                    ref
                                        .read(currentOrgRepositoryProvider)
                                        .deleteBooking(bookingModel.id);
                                  },
                                );
                              },
                            );
                          },
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return BookingDetailsDialog(
                                  bookingModel: bookingModel,
                                );
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: appointmentColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 2,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    maxLines: 1,
                                    maxFontSize: 16,
                                    minFontSize: 12,
                                    overflow: TextOverflow.ellipsis,
                                    bookingModel.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
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
                                        DateFormat(
                                          'hh:mm a',
                                        ).format(bookingModel.timeRange.start),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const Icon(Icons.arrow_right_alt),
                                      AutoSizeText(
                                        maxFontSize: 14,
                                        minFontSize: 10,
                                        DateFormat(
                                          'hh:mm a',
                                        ).format(bookingModel.timeRange.end),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
          recurrenceState: booking.recurrenceState,
          location: booking.location,
          createdAt: booking.createdAt,
          host: booking.host,
          userId: booking.userId,
          id: booking.id,
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
  DateTime getStartTime(int index) {
    return appointments![index].timeRange.start as DateTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].timeRange.end as DateTime;
  }

  @override
  String getDescription(int index) {
    return appointments![index].description as String;
  }

  @override
  String getTitle(int index) {
    return appointments?[index].title as String;
  }

  @override
  BookingModel convertAppointmentToObject(
    BookingModel customData,
    Appointment appointment,
  ) {
    return BookingModel(
      timeRange: customData.timeRange,
      description: customData.description,
      title: customData.title,
      recurrenceState: customData.recurrenceState,
      location: customData.location,
      createdAt: customData.createdAt,
      host: customData.host,
      userId: customData.userId,
      id: customData.id,
    );
  }
}
