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
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: bookingStream.when(
              data: (booking) {
                if (booking == null) {
                  return _buildPinnedStatusSlivers(
                    const Text('Booking not found.'),
                  );
                }
                return [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Main Title - Fixed height
                        Align(
                          alignment: Alignment.center,
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
                              ),
                              child: BookingDetailsContent(booking: booking),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        Spacer(),
                        FooterWidget(moreInfo: true),
                      ],
                    ),
                  ),
                ];
              },
              loading: () => _buildPinnedStatusSlivers(const Loader()),
              error: (error, stack) => _buildPinnedStatusSlivers(
                const Text('Failed to load booking details.'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPinnedStatusSlivers(Widget statusChild) {
    return [
      SliverFillRemaining(
        hasScrollBody: false,
        child: Column(
          children: [
            Expanded(child: Center(child: statusChild)),
            const FooterWidget(moreInfo: true),
          ],
        ),
      ),
    ];
  }
}
