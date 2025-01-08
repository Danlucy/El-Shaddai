import 'package:auto_size_text/auto_size_text.dart';
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

enum TextScaleFactor {
  normal,
  boomer,
  oldMan;

  static TextScaleFactor scaleFactor(double textScaler) {
    if (textScaler > 1.4) {
      return TextScaleFactor.oldMan;
    } else if (textScaler > 1 && textScaler <= 1.4) {
      return TextScaleFactor.boomer;
    } else {
      return TextScaleFactor.normal;
    }
  }
}

class _EventsScreenState extends ConsumerState<BookingScreen> {
  final CalendarController dailyCalendarController = CalendarController();
  final CalendarController monthlyCalendarController = CalendarController();

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final textScaleFactor = TextScaleFactor.scaleFactor(textScale);

    // Determine flex proportions based on TextScaleFactor
    int monthlyFlex = 4; // Default: Equal space
    int dailyFlex = 5; // Default: Equal space

    if (textScaleFactor == TextScaleFactor.oldMan) {
      monthlyFlex = 5; // MonthlyCalendarComponent takes 70%
      dailyFlex = 4; // DailyCalendarComponent takes 30%
    } else if (textScaleFactor == TextScaleFactor.boomer) {
      monthlyFlex = 5; // MonthlyCalendarComponent takes 60%
      dailyFlex = 5; // DailyCalendarComponent takes 40%
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(bookingControllerProvider.notifier).clearState();

          showDialog(
              useRootNavigator: false,
              context: context,
              builder: (context) {
                // print('dadad');
                // print(TextScaleFactor.scaleFactor(textScale));
                // print(textScale);
                return BookingDialog(
                  context,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                );
              });
        },
        backgroundColor: context.colors.primaryContainer,
        child: Icon(
          Icons.add,
          color: context.colors.secondary,
        ),
      ),
      appBar: AppBar(
        title: const AutoSizeText(
          minFontSize: 10, // Minimum font size
          maxFontSize: 20,
          'Book Prayer Watches',
        ),
      ),
      drawer: const GeneralDrawer(),
      body: Column(
        children: [
          Expanded(
            flex: monthlyFlex,
            child: MonthlyCalendarComponent(
              monthlyCalendarController: monthlyCalendarController,
            ),
          ),
          Expanded(
            flex: dailyFlex,
            child: DailyCalendarComponent(
              dailyCalendarController: dailyCalendarController,
            ),
          ),
        ],
      ),
    );
  }
}
