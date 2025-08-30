import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:website/core/widgets/animated_background.dart';
import 'package:website/core/widgets/footer_widget.dart';
import 'package:website/core/widgets/loader.dart';
import 'package:website/features/booking/provider/booking_provider.dart';
import 'package:website/features/booking/widget/booking_details_widget.dart';

class BookingDetailsScreen extends ConsumerWidget {
  const BookingDetailsScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingStream = ref.watch(
      getSingleCurrentOrgBookingStreamProvider(bookingId: bookingId),
    );

    return Scaffold(
      body: AnimatedBackground(
        surfaceColor: Theme.of(context).colorScheme.surface,
        secondaryColor: Theme.of(context).colorScheme.secondary,
        child: bookingStream.when(
          data: (booking) {
            if (booking == null) {
              return const Center(child: Text('Booking not found.'));
            }
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Main Title - Fixed height
                    Align(
                      alignment: AlignmentGeometry.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          'Booking Details',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: context.colors.primary,
                          ),
                        ),
                      ),
                    ),
                    // The core content - Takes available space
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 1200,
                            maxHeight: 1000,
                          ),
                          child: BookingDetailsContent(booking: booking),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const FooterWidget(moreInfo: true),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: Loader()),
          error: (error, stack) =>
              const Center(child: Text('Failed to load booking details.')),
        ),
      ),
    );
  }
}
