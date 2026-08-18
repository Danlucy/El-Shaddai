import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/widgets/glass_container.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:util/util.dart';

import '../../../core/widgets/snack_bar.dart';
import '../../auth/controller/auth_controller.dart';
import '../../booking/presentations/booking_details_dialog.dart';
import '../../booking/provider/booking_provider.dart';
import '../home_booking_selector.dart';
import '../provider/home_provider.dart';
import '../widgets/edit_home_text_dialog.dart';
import '../widgets/general_drawer.dart';

const defaultHomeText =
    'Welcome to EL Shaddai 247 Prayer Altar for the Kingdom Of God. '
    '\n\nThe Lord has prompted us to create the 247 prayer event calendar. '
    'This development is made possible with the appointment of Daniel Ong Zhi '
    'En, undergraduate student of Swineburne University. '
    '\nWe started the development of this application since July 2024. Keep us '
    'in prayer that the heart of our Father will be fulfilled through our young '
    'generation under our guidance. Amen';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
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

  Future<void> _editHomeText(String currentText) async {
    final updated = await showDialog<bool>(
      context: context,
      builder: (context) => EditHomeTextDialog(initialText: currentText),
    );

    if (updated == true && mounted) {
      showSuccessfulSnackBar(context, 'Home message updated.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider).value;
    final homeTextAsync = ref.watch(currentOrgHomeTextProvider);
    final isAdmin = user?.currentRole(ref) == UserRole.admin;

    return Scaffold(
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              heroTag: 'home_text_fab',
              backgroundColor: Colors.transparent,
              tooltip: 'Edit home message',
              onPressed: () =>
                  _editHomeText(homeTextAsync.value ?? defaultHomeText),
              child: GlassContainer(
                child: Icon(Icons.edit, color: context.colors.secondary),
              ),
            )
          : null,
      appBar: AppBar(
        actionsPadding: const EdgeInsets.all(10),
        titleSpacing: 0,
        centerTitle: true,
        title: ref
            .watch(organizationControllerProvider)
            .when(
              data: (organization) => IntrinsicWidth(
                stepWidth: 100,
                child: GlassContainer(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  borderRadius: BorderRadius.circular(16),
                  height: 40,
                  width: double.infinity,
                  blur: 12,
                  child: Center(
                    child: GradientText(
                      organization.displayName,
                      colors: [
                        context.colors.primary,
                        context.colors.primary,
                        context.colors.secondary,
                      ],
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              error: (error, stack) => const Text('Home'),
              loading: () => const SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
      ),
      drawer: const GeneralDrawer(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            if (user?.phoneNumber == null) ...[
              const _PhoneNumberPrompt(),
              const SizedBox(height: 20),
            ],
            Text(
              'Current prayer watch',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ref
                .watch(getCurrentOrgBookingsStreamProvider)
                .when(
                  data: (bookings) {
                    final booking = selectCurrentOrUpcomingBooking(
                      bookings,
                      _now,
                    );
                    if (booking == null) return const _NoFutureBooking();

                    return _BookingHighlight(
                      booking: booking,
                      isLive: isBookingLive(booking, _now),
                      onTap: () => showDialog<void>(
                        context: context,
                        builder: (context) =>
                            BookingDetailsDialog(bookingModel: booking),
                      ),
                    );
                  },
                  error: (error, stack) => const _BookingMessage(
                    icon: Icons.cloud_off_outlined,
                    message: 'Unable to load upcoming bookings.',
                  ),
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            const SizedBox(height: 30),
            homeTextAsync.when(
              data: (text) => _HomeMessage(text: text ?? defaultHomeText),
              error: (error, stack) =>
                  const _HomeMessage(text: defaultHomeText),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeMessage extends StatelessWidget {
  const _HomeMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      minFontSize: 13,
      maxFontSize: 24,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 22,
        color: context.colors.secondary,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _PhoneNumberPrompt extends StatelessWidget {
  const _PhoneNumberPrompt();

  @override
  Widget build(BuildContext context) {
    return Animate(
      onPlay: (controller) => controller.repeat(reverse: true),
      effects: [
        BoxShadowEffect(
          begin: BoxShadow(
            color: Colors.red.withOpac(0.2),
            blurRadius: 6,
            spreadRadius: 1,
          ),
          end: BoxShadow(
            color: Colors.red.withOpac(0.4),
            blurRadius: 10,
            spreadRadius: 4,
          ),
          duration: 2000.ms,
          curve: Curves.easeInOut,
        ),
      ],
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.red.withOpac(0.4)),
        ),
        color: Colors.red.withOpac(0.1),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Please add your phone number in Profile.',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class _BookingHighlight extends StatelessWidget {
  const _BookingHighlight({
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
    final colorScheme = Theme.of(context).colorScheme;
    final accent = isLive ? colorScheme.error : colorScheme.primary;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: accent.withOpac(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLive) ...[
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      isLive ? 'LIVE NOW' : 'UPCOMING',
                      style: TextStyle(
                        color: accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                booking.title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _BookingMetadata(
                icon: Icons.schedule,
                text: _formattedTimeRange(),
              ),
              const SizedBox(height: 6),
              _BookingMetadata(
                icon: Icons.person_outline,
                text: 'Hosted by ${booking.host}',
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'View booking details',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingMetadata extends StatelessWidget {
  const _BookingMetadata({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class _NoFutureBooking extends StatelessWidget {
  const _NoFutureBooking();

  @override
  Widget build(BuildContext context) {
    return const _BookingMessage(
      icon: Icons.event_available_outlined,
      message: 'There are no future bookings in sight.',
    );
  }
}

class _BookingMessage extends StatelessWidget {
  const _BookingMessage({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(height: 10),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
