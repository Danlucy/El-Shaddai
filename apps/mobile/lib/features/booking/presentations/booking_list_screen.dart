import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

import '../../../core/customs/custom_date_time_range.dart';
import '../../../core/widgets/loader.dart';
import '../../../models/booking_model/booking_model.dart';
import '../../../models/user_model/user_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/widgets/confirm_button.dart';
import '../../calendar/widget/booking_details_dialog.dart';
import '../../home/widgets/general_drawer.dart';
import '../repository/booking_repository.dart';
import 'booking_screen.dart';

class BookingListScreen extends ConsumerStatefulWidget {
  const BookingListScreen({super.key});

  @override
  ConsumerState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends ConsumerState<BookingListScreen> {
  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final textScaleFactor = TextScaleFactor.scaleFactor(textScale);

    final user = ref.read(userProvider);
    // Determine flex proportions based on TextScaleFactor
    double appointmentHeight = 70; // Default: Equal space

    if (textScaleFactor == TextScaleFactor.oldMan) {
      appointmentHeight = 110; // DailyCalendarComponent takes 30%
    } else if (textScaleFactor == TextScaleFactor.boomer) {
      appointmentHeight = 90; // DailyCalendarComponent takes 30%
    }
    final bookingStream = ref.watch(bookingStreamProvider());
    return Scaffold(
      drawer: const GeneralDrawer(),
      appBar: AppBar(
        title: const Text(
          'Prayer Watches',
        ),
      ),
      body: bookingStream.when(
          data: (data) {
            return SfCalendar(
              showNavigationArrow: true,
              view: CalendarView.schedule,
              scheduleViewSettings: ScheduleViewSettings(
                dayHeaderSettings: const DayHeaderSettings(
                  width: 60,
                ),
                appointmentItemHeight: appointmentHeight,
                monthHeaderSettings: const MonthHeaderSettings(
                  height: 80,
                ),
                hideEmptyScheduleWeek: true,
              ),
              showDatePickerButton: true,
              appointmentBuilder:
                  (BuildContext context, CalendarAppointmentDetails details) {
                BookingModel bookingModel = details.appointments.first;
                return GestureDetector(
                  onLongPress: () {
                    if (bookingModel.userId != user?.uid &&
                        user?.role != UserRole.admin) {
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
                                    .read(bookingRepositoryProvider)
                                    .deleteBooking(bookingModel.id);
                              });
                        });
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
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
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
                                DateFormat('hh:mm a')
                                    .format(bookingModel.timeRange.start),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Icon(Icons.arrow_right_alt),
                              AutoSizeText(
                                maxFontSize: 14,
                                minFontSize: 10,
                                DateFormat('hh:mm a')
                                    .format(bookingModel.timeRange.end),
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
              scheduleViewMonthHeaderBuilder: (BuildContext buildContext,
                  ScheduleViewMonthHeaderDetails details) {
                return Container(
                  color: Theme.of(context).colorScheme.onPrimary,
                  child: Center(
                    child: AutoSizeText(
                      maxFontSize: 24,
                      minFontSize: 16,
                      DateFormat('MMMM yyyy').format(details.date),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                  ),
                );
              },
            );
          },
          error: (error, stack) {
            return const Center(
              child: Text('Error'),
            );
          },
          loading: () => const Loader()),
    );
  }
}

_AppointmentDataSource _getCalendarDataSource(List<BookingModel> bookingModel) {
  List<BookingModel> appointments = <BookingModel>[];
  for (BookingModel booking in bookingModel) {
    int duration = booking.timeRange.end.day - booking.timeRange.start.day;
    for (int i = 0; i < duration + 1; i++) {
      DateTime appointmentDate = booking.timeRange.start.add(Duration(days: i));

      // For the first day, set the start time to the original start time
      DateTime currentStartTime = (i == 0)
          ? booking.timeRange.start
          : DateTime(appointmentDate.year, appointmentDate.month,
              appointmentDate.day, 0, 0);

      // For the last day, set the end time to the original end time
      DateTime currentEndTime = (i == duration)
          ? booking.timeRange.end
          : DateTime(appointmentDate.year, appointmentDate.month,
              appointmentDate.day, 23, 59);

      appointments.add(BookingModel(
          timeRange:
              CustomDateTimeRange(start: currentStartTime, end: currentEndTime),
          description: booking.description,
          title: booking.title,
          recurrenceState: booking.recurrenceState,
          location: booking.location,
          createdAt: booking.createdAt,
          host: booking.host,
          userId: booking.userId,
          id: booking.id));
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
      BookingModel customData, Appointment appointment) {
    return BookingModel(
        timeRange: customData.timeRange,
        description: customData.description,
        title: customData.title,
        recurrenceState: customData.recurrenceState,
        location: customData.location,
        createdAt: customData.createdAt,
        host: customData.host,
        userId: customData.userId,
        id: customData.id);
  }
}
