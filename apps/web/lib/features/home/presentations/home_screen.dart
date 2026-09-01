import 'dart:async';

import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:models/models.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:website/core/widgets/animated_background.dart';
import 'package:website/core/widgets/footer_widget.dart';
import 'package:website/core/widgets/glass_button.dart';
import 'package:website/core/widgets/glass_container.dart';
import 'package:website/core/widgets/organization_drop_down_button.dart';
import 'package:website/features/booking/provider/booking_provider.dart';
import 'package:website/features/home/home_booking_selector.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late DateTime _now;
  Timer? _clock;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _clock = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  void goBooking() {
    context.go('/list');
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: GlassContainer(
              borderRadius: BorderRadius.circular(24),
              backgroundColor: context.colors.surface,
              borderColor: context.colors.outlineVariant,
              borderWidth: 1.2,
              blur: 16,
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: context.colors.primary.withOpac(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.help_outline_rounded,
                          color: context.colors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'How to Join the Altar',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: context.colors.onSurface,
                              ),
                            ),
                            Text(
                              'Step-by-step participation guide',
                              style: TextStyle(
                                fontSize: 13,
                                color: context.colors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded, size: 20),
                        color: context.colors.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildHelpItem(
                    number: '1',
                    title: 'Select Prayer Altar',
                    description:
                        'Choose your desired prayer altar from the dropdown selector on the home page.',
                  ),
                  const SizedBox(height: 14),
                  _buildHelpItem(
                    number: '2',
                    title: 'Open Prayer List',
                    description:
                        'Click "View Prayer List" to access the live 24/7 prayer watch schedule.',
                  ),
                  const SizedBox(height: 14),
                  _buildHelpItem(
                    number: '3',
                    title: 'Choose a Prayer Watch',
                    description:
                        'Select the 2-hour watch session you wish to join.',
                  ),
                  const SizedBox(height: 14),
                  _buildHelpItem(
                    number: '4',
                    title: 'Access Zoom or Location',
                    description:
                        'Click to join the session to display the live Zoom credentials or physical meeting location.',
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.primary,
                        foregroundColor: context.colors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Got It',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHelpItem({
    required String number,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.colors.primary.withOpac(0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: context.colors.primary.withOpac(0.5),
              width: 1,
            ),
          ),
          child: Text(
            number,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: context.colors.primary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.colors.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: context.colors.secondary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnimatedBackground(
        surfaceColor: context.colors.surface,
        secondaryColor: context.colors.secondary,
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 16.0 : (isDesktop ? 32.0 : 24.0),
                        vertical: isMobile ? 16.0 : 28.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Top Spacing for transparent AppBar
                          Gap(isMobile ? 50 : 60),

                          // 1. Hero Section
                          _buildHeroSection(context, isDesktop, isMobile)
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .slideY(begin: 0.04, end: 0, duration: 400.ms),

                          Gap(isMobile ? 48 : 64),

                          // 2. Interactive 3-Step Guide Section
                          _buildHowItWorksSection(context, isDesktop, isMobile)
                              .animate()
                              .fadeIn(delay: 150.ms, duration: 400.ms)
                              .slideY(begin: 0.04, end: 0, duration: 400.ms),

                          Gap(isMobile ? 48 : 64),

                          // 3. Mobile App Download Section
                          _buildAppDownloadSection(context, isDesktop, isMobile)
                              .animate()
                              .fadeIn(delay: 250.ms, duration: 400.ms)
                              .slideY(begin: 0.04, end: 0, duration: 400.ms),

                          Gap(isMobile ? 40 : 60),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Footer pinned to the bottom of the page
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    const Spacer(),
                    const FooterWidget(moreInfo: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. HERO SECTION
  // ==========================================
  Widget _buildHeroSection(
    BuildContext context,
    bool isDesktop,
    bool isMobile,
  ) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Hero Copy & Fast Action Box
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroTitle(context, isMobile: false),
                const Gap(16),
                _buildHeroSubtitle(context, isMobile: false),
                const Gap(28),
                _buildActionCard(context, isMobile: false),
              ],
            ),
          ),
          const SizedBox(width: 48),
          // Right: Visual Logo Card with Ambient Glow
          Expanded(
            flex: 5,
            child: Center(
              child: _buildHeroVisualCard(context, isDesktop: true),
            ),
          ),
        ],
      );
    } else {
      // Mobile / Tablet Stacked Layout
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeroTitle(context, isMobile: true),
          const Gap(14),
          _buildHeroSubtitle(context, isMobile: true),
          const Gap(24),
          _buildHeroVisualCard(context, isDesktop: false),
          const Gap(24),
          _buildActionCard(context, isMobile: true),
        ],
      );
    }
  }

  Widget _buildHeroTitle(BuildContext context, {required bool isMobile}) {
    return RichText(
      textAlign: isMobile ? TextAlign.center : TextAlign.start,
      text: TextSpan(
        style: TextStyle(
          fontSize: isMobile ? 26 : 38,
          fontWeight: FontWeight.w400,
          color: context.colors.onSurface,
          height: 1.25,
          letterSpacing: -0.5,
        ),
        children: [
          const TextSpan(
            text: 'Welcome to\n',
            style: TextStyle(fontWeight: FontWeight.w300),
          ),
          TextSpan(
            text: 'EL Shaddai 24/7 ',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: context.colors.primary,
              letterSpacing: 0.2,
            ),
          ),
          const TextSpan(
            text: 'Prayer Altar\n',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(
            text: 'for the Kingdom of God',
            style: TextStyle(
              fontSize: isMobile ? 20 : 28,
              fontWeight: FontWeight.w500,
              color: context.colors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSubtitle(BuildContext context, {required bool isMobile}) {
    return Text(
      'A continuous unbroken chain of non-stop prayer and intercession uniting believers worldwide. Select your prayer altar to explore schedules and join active sessions.',
      textAlign: isMobile ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        fontSize: isMobile ? 14 : 16,
        color: context.colors.secondary,
        height: 1.5,
      ),
    );
  }

  Widget _buildHeroVisualCard(BuildContext context, {required bool isDesktop}) {
    final double cardHeight = isDesktop ? 360 : 240;
    final double logoHeight = isDesktop ? 220 : 140;

    return Container(
      width: isDesktop ? 380 : double.infinity,
      constraints: const BoxConstraints(maxWidth: 380),
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withOpac(0.12),
            blurRadius: 35,
            spreadRadius: 2,
          ),
        ],
      ),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(24),
        backgroundColor: context.colors.surface,
        borderColor: context.colors.outlineVariant,
        borderWidth: 1.2,
        blur: 14,
        padding: const EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/logo/main_logo3.png',
            height: logoHeight,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, {required bool isMobile}) {
    final double elementWidth = isMobile ? 320 : 420;

    return Container(
      width: isMobile ? double.infinity : 480,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpac(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(20),
        backgroundColor: context.colors.surface,
        borderColor: context.colors.primary.withOpac(0.3),
        borderWidth: 1.2,
        blur: 16,
        padding: EdgeInsets.all(isMobile ? 18 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.touch_app_rounded,
                  size: 20,
                  color: context.colors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Join a Prayer Watch',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.colors.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Step 1: Organization Dropdown
            Text(
              'Step 1: Choose Prayer Altar',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.colors.secondary,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: OrganizationSelectionDropdown(
                height: 52,
                width: elementWidth,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 18),
            Text(
              'Current prayer watch',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.colors.secondary,
              ),
            ),
            const SizedBox(height: 8),
            ref
                .watch(getCurrentOrgBookingsStreamProvider)
                .when(
                  data: (bookings) {
                    final booking = selectCurrentOrUpcomingBooking(
                      bookings,
                      _now,
                    );
                    if (booking == null) {
                      return const _BookingStatusMessage(
                        icon: Icons.event_available_outlined,
                        message: 'There are no future bookings in sight.',
                      );
                    }

                    return _CurrentBookingCard(
                      booking: booking,
                      isLive: isBookingLive(booking, _now),
                      onTap: () => context.go('/booking/${booking.id}'),
                    );
                  },
                  loading: () => const SizedBox(
                    height: 72,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, stack) => const _BookingStatusMessage(
                    icon: Icons.cloud_off_outlined,
                    message: 'Unable to load upcoming bookings.',
                  ),
                ),

            const SizedBox(height: 18),

            // Step 2: Prayer List CTA Button
            Text(
              'Step 2: View Active Schedule',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.colors.secondary,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: GlassmorphicButton(
                width: elementWidth,
                height: 52,
                borderRadius: 12,
                fontSize: 16,
                textColour: context.colors.primary,
                text: 'View Prayer List',
                icon: Icons.calendar_today_rounded,
                onPressed: goBooking,
              ),
            ),

            const SizedBox(height: 14),

            // Help Trigger Link
            Center(
              child: TextButton.icon(
                onPressed: () => _showHelpDialog(context),
                icon: Icon(
                  Icons.help_outline_rounded,
                  size: 16,
                  color: context.colors.primary,
                ),
                label: Text(
                  'Need help joining? View 4-step guide',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: context.colors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 2. HOW IT WORKS SECTION (3 STEPS)
  // ==========================================
  Widget _buildHowItWorksSection(
    BuildContext context,
    bool isDesktop,
    bool isMobile,
  ) {
    return Column(
      children: [
        const Gap(28),
        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildStepCard(
                  context,
                  stepNumber: '01',
                  icon: Icons.tune_rounded,
                  title: 'Select Prayer Altar',
                  description:
                      'Choose your desired global or regional altar from the organization selector.',
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildStepCard(
                  context,
                  stepNumber: '02',
                  icon: Icons.schedule_rounded,
                  title: 'Browse Watch Times',
                  description:
                      'Explore the 24-hour prayer list to find an active 2-hour watch slot that matches your time.',
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildStepCard(
                  context,
                  stepNumber: '03',
                  icon: Icons.videocam_rounded,
                  title: 'Connect & Intercede',
                  description:
                      'Click to join the session to instantly view live Zoom credentials or physical meeting location.',
                ),
              ),
            ],
          )
        else
          Column(
            children: [
              _buildStepCard(
                context,
                stepNumber: '01',
                icon: Icons.tune_rounded,
                title: 'Select Prayer Altar',
                description:
                    'Choose your desired global or regional altar from the organization selector.',
              ),
              const SizedBox(height: 16),
              _buildStepCard(
                context,
                stepNumber: '02',
                icon: Icons.schedule_rounded,
                title: 'Browse Watch Times',
                description:
                    'Explore the 24-hour prayer list to find an active 2-hour watch slot that matches your time.',
              ),
              const SizedBox(height: 16),
              _buildStepCard(
                context,
                stepNumber: '03',
                icon: Icons.videocam_rounded,
                title: 'Connect & Intercede',
                description:
                    'Click to join the session to instantly view live Zoom credentials or physical meeting location.',
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildStepCard(
    BuildContext context, {
    required String stepNumber,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpac(0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(18),
        backgroundColor: context.colors.surface,
        borderColor: context.colors.outlineVariant,
        borderWidth: 1,
        blur: 12,
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withOpac(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: context.colors.primary, size: 22),
                ),
                Text(
                  stepNumber,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: context.colors.primary.withOpac(0.35),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 13,
                color: context.colors.secondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 3. MOBILE APP DOWNLOAD SECTION
  // ==========================================
  Widget _buildAppDownloadSection(
    BuildContext context,
    bool isDesktop,
    bool isMobile,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withOpac(0.1),
            blurRadius: 30,
            spreadRadius: 1,
          ),
        ],
      ),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(24),
        backgroundColor: context.colors.surface,
        borderColor: context.colors.outlineVariant,
        borderWidth: 1.2,
        blur: 14,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 36,
          vertical: isMobile ? 24 : 36,
        ),
        child: isDesktop
            ? Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAppBadge(context),
                        const SizedBox(height: 14),
                        Text(
                          'Take the Prayer Altar Anywhere',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: context.colors.onSurface,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Download the Android mobile app for fast access to prayer watches, real-time schedule updates, and one-tap Zoom access from your phone.',
                          style: TextStyle(
                            fontSize: 14,
                            color: context.colors.secondary,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 36),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const DownloadButtons(borderRadius: 16),
                        const SizedBox(height: 10),
                        Text(
                          'iOS or IPhone please use web only.\nWeb version is fully mobile compatible.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: context.colors.secondary.withOpac(0.8),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildAppBadge(context),
                  const SizedBox(height: 14),
                  Text(
                    'Take the Prayer Altar Anywhere',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: context.colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Download the Android mobile app for fast access to prayer watches and one-tap Zoom meetings on the go.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: context.colors.secondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const DownloadButtons(borderRadius: 16),
                  const SizedBox(height: 10),
                  Text(
                    'iOS App Store version coming soon.\nWeb version is fully mobile compatible.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: context.colors.secondary.withOpac(0.8),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildAppBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: context.colors.primary.withOpac(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.phone_android_rounded,
            size: 14,
            color: context.colors.primary,
          ),
          const SizedBox(width: 6),
          Text(
            'MOBILE ACCESS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: context.colors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SECTION HEADER HELPER
  // ==========================================
  Widget _buildSectionHeader(
    BuildContext context, {
    required String tag,
    required String title,
    required String subtitle,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: context.colors.primary.withOpac(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            tag,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: context.colors.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: context.colors.onSurface,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: context.colors.secondary),
        ),
      ],
    );
  }
}

class _CurrentBookingCard extends StatelessWidget {
  const _CurrentBookingCard({
    required this.booking,
    required this.isLive,
    required this.onTap,
  });

  final BookingModel booking;
  final bool isLive;
  final VoidCallback onTap;

  String _formattedTimeRange() {
    final start = booking.timeRange.start;
    final end = booking.timeRange.end;
    final date = DateFormat('EEE, d MMM yyyy').format(start);
    final startTime = DateFormat.jm().format(start);
    final endTime = DateFormat.jm().format(end);
    final isSameDay =
        start.year == end.year &&
        start.month == end.month &&
        start.day == end.day;

    if (isSameDay) return '$date • $startTime – $endTime';
    return '$date, $startTime – '
        '${DateFormat('EEE, d MMM yyyy').format(end)}, $endTime';
  }

  @override
  Widget build(BuildContext context) {
    final accent = isLive ? context.colors.error : context.colors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: accent.withOpac(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: accent.withOpac(0.35)),
          ),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                  boxShadow: isLive
                      ? [
                          BoxShadow(
                            color: accent.withOpac(0.45),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLive ? 'LIVE NOW' : 'UPCOMING',
                      style: TextStyle(
                        color: accent,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      booking.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.colors.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formattedTimeRange(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.colors.secondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_rounded,
                size: 20,
                color: context.colors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingStatusMessage extends StatelessWidget {
  const _BookingStatusMessage({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: context.colors.surface.withOpac(0.65),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: context.colors.secondary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: context.colors.secondary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
