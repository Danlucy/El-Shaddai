import 'package:auto_size_text/auto_size_text.dart';
import 'package:constants/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../models/user_model/user_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../../calendar/presentations/daily_calendar_component.dart';
import '../../calendar/presentations/monthly_calendar_component.dart';
import '../../home/widgets/general_drawer.dart';
import '../controller/booking_controller.dart';
import 'booking_dialog.dart';

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
    final user = ref.read(userProvider);
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
      floatingActionButton: (user?.role == UserRole.intercessor)
          ? null
          : FloatingActionButton(
              onPressed: () {
                ref.read(bookingControllerProvider.notifier).clearState();

                showDialog(
                    useRootNavigator: false,
                    context: context,
                    builder: (context) {
                      return BookingDialog(
                        context,
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
