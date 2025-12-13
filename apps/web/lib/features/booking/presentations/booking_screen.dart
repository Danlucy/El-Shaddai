import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:util/util.dart';
import 'package:website/core/widgets/animated_background.dart';
import 'package:website/core/widgets/glass_container.dart';
import 'package:website/features/auth/controller/auth_controller.dart';
import 'package:website/features/booking/controller/booking_controller.dart';
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
            const Gap(50),
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
            const _MonthlyCalendarWidget(aspectRatio: 1),
            const Gap(15),
            _CalendarDisplaySection(viewMode: CalendarView.timelineDay),
            const Gap(50),
          ],
        ),
      ],
    );
  }

  // ✅ 2. Updated Desktop Layout
  Widget _buildDesktopLayout(BuildContext context, bool canCreate) {
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
                  _DesktopCalendarToolSection(canCreate),
                  const Gap(15), // Spacing between panels
                  _CalendarDisplaySection(viewMode: CalendarView.week),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Expanded _CalendarDisplaySection({required CalendarView viewMode}) {
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
          child: WeeklyCalendarComponent(view: viewMode),
        ),
      ),
    );
  }

  SizedBox _DesktopCalendarToolSection(bool canCreate) {
    final user = ref.read(userProvider).value;
    bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return SizedBox(
      width: 350,
      height: double.infinity,
      child: Column(
        children: [
          const _MonthlyCalendarWidget(aspectRatio: 0.8),
          const Spacer(),
          // ✅ Desktop Source Hero
          if (canCreate)
            Hero(
              tag: "booking_fab",
              child: OutlinedButton(
                onPressed: () {
                  if (user?.currentRole(ref) == UserRole.intercessor ||
                      user?.currentRole(ref) == UserRole.observer ||
                      isDesktop) {
                    ref.read(bookingControllerProvider.notifier).clearState();
                    context.go('/booking/create');
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    "Create Prayer Watch",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w100),
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
    final user = ref.read(userProvider).value;
    final canCreate = user?.isWatchLeaderOrHigher ?? false;
    ref.watch(calendarDateNotifierProvider);
    bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    return Scaffold(
      floatingActionButton: (!canCreate || isDesktop)
          ? null
          : SizedBox(
              width: isMobile ? 50 : 80,
              height: isMobile ? 50 : 80,
              child: GestureDetector(
                onTap: () {
                  ref.read(bookingControllerProvider.notifier).clearState();
                  context.go('/booking/create');
                },
                // ✅ ADDED: Mobile Source Hero
                child: Hero(
                  tag: "booking_fab",
                  child: GlassContainer(
                    width: double.infinity,
                    height: double.infinity,
                    blur: 10,
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: context.colors.secondary,
                        size: 35,
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
                child: isDesktop
                    ? _buildDesktopLayout(context, canCreate)
                    : _buildMobileLayout(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthlyCalendarWidget extends ConsumerWidget {
  const _MonthlyCalendarWidget({required this.aspectRatio, super.key});
  final double aspectRatio;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(calendarDateNotifierProvider);

    return Column(
      children: [
        DateHeaderWidget(selectedDate: selectedDate),
        const Gap(10),
        AspectRatio(
          aspectRatio: aspectRatio,
          child: const MonthlyCalendarComponent(),
        ),
      ],
    );
  }
}
