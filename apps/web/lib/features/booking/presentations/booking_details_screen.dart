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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final content = bookingStream.when<List<Widget>>(
                data: (booking) {
                  if (booking == null) {
                    return _buildStatus(const Text('Booking not found.'));
                  }
                  return [
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: BookingDetailsContent(booking: booking),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Spacer(),
                  ];
                },
                loading: () => _buildStatus(const Loader()),
                error: (error, stack) =>
                    _buildStatus(const Text('Failed to load booking details.')),
              );

              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          ...content,
                          const FooterWidget(moreInfo: true),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStatus(Widget statusChild) {
    return [Expanded(child: Center(child: statusChild))];
  }
}
