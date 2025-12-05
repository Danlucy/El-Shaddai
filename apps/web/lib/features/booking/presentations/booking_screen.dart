import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:website/core/widgets/animated_background.dart';
import 'package:website/features/booking/presentations/date_header_widget.dart';
import 'package:website/features/booking/presentations/monthly_calendar_widget.dart';
import 'package:website/features/booking/presentations/weekly_calendar_widget.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({this.bookingModel, super.key});
  final BookingModel? bookingModel;
  static final formKey = GlobalKey<FormState>();

  @override
  ConsumerState createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  // ✅ 1. Mobile Layout
  Widget _buildMobileLayout(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Center(
              child: Text(
                'Prayer Event Calendar',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: context.colors.primary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Calendar fills remaining space
            Expanded(
              child: GlassmorphicContainer(
                width: double.infinity,
                height: double.infinity,
                borderRadius: 20,
                linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpac(0.2),
                    Colors.white.withOpac(0.1),
                  ],
                  stops: const [0.1, 1],
                ),
                border: 2,
                blur: 15,
                borderGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpac(0.5),
                    Colors.white.withOpac(0.5),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: MonthlyCalendarComponent(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ✅ 2. Updated Desktop Layout
  Widget _buildDesktopLayout(BuildContext context, DateTime selectedDate) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Prayer Event Calendar',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: context.colors.primary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Expanded forces it to take all remaining height
            Expanded(
              child: Row(
                children: [
                  // --- LEFT SIDEBAR (Monthly Calendar) ---
                  _CalendarToolSection(selectedDate),
                  const Gap(15), // Spacing between panels
                  _CalendarDisplaySection(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Expanded _CalendarDisplaySection() {
    return Expanded(
      child: GlassmorphicContainer(
        width: double.infinity,
        height: double.infinity,
        borderRadius: 20,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withOpac(0.2), Colors.white.withOpac(0.1)],
          stops: const [0.1, 1],
        ),
        border: 2,
        blur: 15,
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withOpac(0.5), Colors.white.withOpac(0.5)],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: WeeklyCalendarComponent(),
        ),
      ),
    );
  }

  SizedBox _CalendarToolSection(DateTime selectedDate) {
    return SizedBox(
      width: 350,
      height: double.infinity,
      child: Column(
        children: [
          DateHeaderWidget(selectedDate: selectedDate),
          Gap(10),
          AspectRatio(aspectRatio: 0.8, child: MonthlyCalendarComponent()),
          Spacer(),
          OutlinedButton(
            onPressed: () {
              context.go('/booking/create');
            },
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              child: Text(
                "Create Prayer Watch",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w100),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(calendarDateNotifierProvider);

    ref.watch(calendarDateNotifierProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 1. Background Layer
          Positioned.fill(
            child: AnimatedBackground(
              surfaceColor: context.colors.surface,
              secondaryColor: context.colors.secondary,
              child: const SizedBox.expand(),
            ),
          ),

          // 2. Content Layer
          Positioned.fill(
            child: SafeArea(
              bottom: true,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: ResponsiveBreakpoints.of(context).largerThan(TABLET)
                    ? _buildDesktopLayout(context, selectedDate)
                    : _buildMobileLayout(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
