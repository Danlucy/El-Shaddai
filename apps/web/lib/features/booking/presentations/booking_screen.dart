import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:repositories/repositories.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:website/core/widgets/animated_background.dart';
import 'package:website/features/booking/presentations/monthly_calendar_widget.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  _buildMobileLayout(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Align(
      alignment: Alignment.topCenter,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Prayer Event Calendar',
                style: TextStyle(
                  fontSize: ResponsiveValue<double>(
                    context,
                    defaultValue: 20,
                    conditionalValues: [
                      Condition.between(start: 0, end: 450, value: 20),
                      const Condition.between(start: 801, end: 1000, value: 24),
                      const Condition.between(
                          start: 1001, end: 1200, value: 28),
                      const Condition.between(
                          start: 1201, end: 1920, value: 30),
                      const Condition.between(
                          start: 1921, end: 3000, value: 34),
                    ],
                  ).value,
                  fontWeight: FontWeight.bold,
                  color: context.colors.primary,
                ),
              ),
              GlassmorphicContainer(
                width: width * 0.9, // Fallback value
                height: width * 0.8, // Fallback value
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
                  padding: EdgeInsets.all(
                    ResponsiveValue<double>(
                      defaultValue: 16,
                      context,
                      conditionalValues: [
                        const Condition.between(
                            start: 0, end: 350, value: 12.0),
                        const Condition.between(
                            start: 351, end: 450, value: 16.0),
                      ],
                    ).value,
                  ),
                  child: MonthlyCalendarComponent(),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 80,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpac(0.15),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildDesktopLayout(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter, // Center the content
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Prayer Event Calendar',
                style: TextStyle(
                  fontSize: ResponsiveValue<double>(
                    context,
                    defaultValue: 20,
                    conditionalValues: [
                      Condition.between(start: 0, end: 450, value: 20),
                      const Condition.between(start: 801, end: 1000, value: 24),
                      const Condition.between(
                          start: 1001, end: 1200, value: 28),
                      const Condition.between(
                          start: 1201, end: 1920, value: 30),
                      const Condition.between(
                          start: 1921, end: 3000, value: 34),
                    ],
                  ).value,
                  fontWeight: FontWeight.bold,
                  color: context.colors.primary,
                ),
              ),
              GlassmorphicContainer(
                width: ResponsiveValue<double>(
                  context,
                  defaultValue: 700.0,
                  conditionalValues: [
                    // 801-1920px (DESKTOP)
                    const Condition.between(
                        start: 801, end: 1000, value: 700.0),
                    const Condition.between(
                        start: 1001, end: 1200, value: 800.0),
                    const Condition.between(
                        start: 1201, end: 1500, value: 900.0),
                    const Condition.between(
                        start: 1501, end: 1920, value: 900.0),
                    const Condition.between(
                        start: 1921, end: 2500, value: 800.0),
                    const Condition.between(
                        start: 2501, end: 3000, value: 1200.0),
                  ],
                ).value, // Fallback value
                height: ResponsiveValue<double>(
                  context,
                  conditionalValues: [
                    // 801-1920px (DESKTOP)
                    const Condition.between(
                        start: 801, end: 1000, value: 650.0),
                    const Condition.between(
                        start: 1001, end: 1200, value: 700.0),
                    const Condition.between(
                        start: 1201, end: 1500, value: 750.0),
                    const Condition.between(
                        start: 1501, end: 1920, value: 750.0),
                    // 1921+ (4K)
                    const Condition.between(
                        start: 1921, end: 2500, value: 700.0),
                    const Condition.between(
                        start: 2501, end: 3000, value: 900.0),
                  ],
                ).value, // Fallback value
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
                  padding: EdgeInsets.all(
                    ResponsiveValue<double>(
                      defaultValue: 20,
                      context,
                      conditionalValues: [
                        const Condition.between(
                            start: 451, end: 800, value: 20.0), // TABLET
                        const Condition.between(
                            start: 801, end: 1920, value: 24.0), // DESKTOP
                        const Condition.between(
                            start: 1921, end: 3000, value: 32.0), // 4K
                      ],
                    ).value,
                  ),
                  child: MonthlyCalendarComponent(),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 80,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(calendarDateNotifierProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnimatedBackground(
        surfaceColor: context.colors.surface,
        secondaryColor: context.colors.secondary,
        child: SafeArea(
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: ResponsiveBreakpoints.of(context).largerThan(TABLET)
                ? _buildDesktopLayout(context)
                : _buildMobileLayout(context),
          ),
        ),
      ),
    );
  }
}
