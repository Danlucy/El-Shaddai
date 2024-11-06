import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/features/booking/controller/booking_controller.dart';
import 'package:el_shaddai/features/booking/presentations/booking_dialog.dart';
import 'package:el_shaddai/features/calendar/presentations/daily_calendar_component.dart';
import 'package:el_shaddai/features/calendar/presentations/monthly_calendar_component.dart';
import 'package:el_shaddai/features/home/widgets/general_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<BookingScreen> {
  final CalendarController dailyCalendarController = CalendarController();
  final CalendarController monthlyCalendarController = CalendarController();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(bookingControllerProvider.notifier).clearState();

          showDialog(
              useRootNavigator: false,
              context: context,
              builder: (dcontext) {
                return BookingDialog(dcontext, width: width, height: height);
              });
        },
        backgroundColor: context.colors.primaryContainer,
        child: Icon(
          Icons.add,
          color: context.colors.secondary,
        ),
      ),
      appBar: AppBar(title: const Text('Prayer Events')),
      drawer: const GeneralDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MonthlyCalendarComponent(
            monthlyCalendarController: monthlyCalendarController,
          ),
          DailyCalendarComponent(
            dailyCalendarController: dailyCalendarController,
          )
        ],
      ),
    );
  }
}
