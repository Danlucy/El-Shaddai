import 'package:auto_size_text/auto_size_text.dart';
import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:website/core/utility/utility.dart';
import 'package:website/core/widgets/animated_background.dart';
import 'package:website/core/widgets/calendar_widget.dart';
import 'package:website/core/widgets/confirm_button.dart';
import 'package:website/core/widgets/footer_widget.dart';
import 'package:website/core/widgets/loader.dart';
import 'package:website/features/auth/controller/auth_controller.dart';

import '../../participant/controller/participant_controller.dart';

class BookingDetailsScreen extends ConsumerWidget {
  const BookingDetailsScreen({
    super.key,
    required this.bookingId,
  });

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingStream =
        ref.watch(bookingStreamProvider(bookingId: bookingId));
    final user = ref.watch(userProvider);

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
                    child: Column(children: [
              // ✅ Main content with padding
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'Booking Details',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: context.colors.primary,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Your main content
                      GlassmorphicContainer(
                        width: 1200,
                        height: MediaQuery.sizeOf(context).height * 0.85,
                        borderRadius: 20,
                        blur: 15,
                        border: 2,
                        linearGradient: LinearGradient(
                          colors: [
                            Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(0.1),
                            Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderGradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.8),
                            Colors.white.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: ResponsiveRowColumn(
                            layout: ResponsiveBreakpoints.of(context)
                                    .largerThan(TABLET)
                                ? ResponsiveRowColumnType.ROW
                                : ResponsiveRowColumnType.COLUMN,
                            rowCrossAxisAlignment: CrossAxisAlignment.start,
                            rowSpacing: 40,
                            columnSpacing: 20,
                            children: [
                              ResponsiveRowColumnItem(
                                rowFlex: 2,
                                child: _MainDetailsColumn(booking: booking),
                              ),
                              ResponsiveRowColumnItem(
                                rowFlex: 1,
                                child: _ParticipantsAndActionsColumn(
                                  booking: booking,
                                  user: user,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // 👇 Footer comes after everything else, so it's visible
                    ],
                  ),
                ),
              ),
              FooterWidget(moreInfo: true),
            ])));
          },
          loading: () => const Center(child: Loader()),
          error: (error, stack) =>
              const Center(child: Text('Failed to load booking details.')),
        ),
      ),
    );
  }
}

// Helper Widget for the main details column
class _MainDetailsColumn extends StatelessWidget {
  const _MainDetailsColumn({required this.booking});
  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    print(booking.location.chords);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          booking.title,
          style: Theme.of(context).textTheme.headlineLarge,
          maxLines: 2,
        ),
        Text(
          'Hosted by: ${booking.host}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Gap(24),
        // Date and Time Range
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                CalendarWidget(
                    date: booking.timeRange.start,
                    color: Theme.of(context).colorScheme.primary),
                const Gap(4),
                Text(DateFormat.jm().format(booking.timeRange.start)),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.arrow_right_alt_outlined, size: 32),
            ),
            Column(
              children: [
                CalendarWidget(
                    date: booking.timeRange.end,
                    color: Theme.of(context).colorScheme.primary),
                const Gap(4),
                Text(DateFormat.jm().format(booking.timeRange.end)),
              ],
            ),
          ],
        ),
        const Gap(24),
        // Description
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleMedium,
        ),

        const Gap(8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(booking.description),
        ),

        const Gap(24),
        // Location Details
        if (booking.location.address != null) ...[
          Text(
            'Location',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Gap(8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 20),
              const Gap(8),
              Expanded(child: Text(booking.location.address!)),
            ],
          ),
        ],
        const Gap(16),
        // Google Map

        if (booking.location.chords != null)
          SizedBox(
            height: 250,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: booking.location.chords!,
                  zoom: 13,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId("1"),
                    position: booking.location.chords!,
                  )
                },
              ),
            ),
          ),
      ],
    );
  }
}

// Helper Widget for participants and actions
class _ParticipantsAndActionsColumn extends ConsumerWidget {
  const _ParticipantsAndActionsColumn({required this.booking, this.user});
  final BookingModel booking;
  final UserModel? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participantStream =
        ref.watch(participantRepositoryProvider).getAllParticipants(booking.id);
    final participationFunction =
        ref.read(participantControllerProvider(booking.id).notifier);

    return IntrinsicHeight(
      child: GlassmorphicContainer(
        width: double.infinity,
        height: double.infinity,
        borderRadius: 16,
        blur: 20, // how much blur you want
        alignment: Alignment.center,
        border: 2,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.05),
          ],
          stops: const [0.1, 1],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.5),
          ],
        ),
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 4, vertical: 2),
          child: Column(
            children: [
              // Zoom & Meeting Info
              if (booking.location.web != null) ...[
                Text(
                  'Meeting Info',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Gap(8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        launchURL(booking.location.web!);
                        if (booking.password != null) {
                          Clipboard.setData(
                              ClipboardData(text: booking.password!));
                        }
                      },
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/zoom.png'),
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(
                              text: booking.location.meetingID()));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Meeting ID copied to clipboard')));
                        },
                        child: Text(
                          booking.location.meetingID(spaced: true),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    if (booking.password != null)
                      IconButton(
                        icon: const Icon(Icons.key),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Meeting Password'),
                            content: SelectableText(booking.password!),
                            actions: [
                              TextButton(
                                child: const Text('Copy & Close'),
                                onPressed: () {
                                  Clipboard.setData(
                                      ClipboardData(text: booking.password!));
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
              const Gap(32),
              // Participants List
              Text(
                'Intercessors',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Gap(8),
              StreamBuilder<List<UserModel>>(
                stream: participantStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loader();
                  }
                  final participants = snapshot.data ?? [];
                  final bool isJoined = participants
                      .any((userModel) => userModel.uid == user?.uid);

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        if (participants.isEmpty)
                          const Text('No intercessors yet.'),
                        ...participants.map((userModel) => ListTile(
                              title: Text(userModel.name),
                              onTap: () {},

                              // onTap: () => ProfileRoute(userModel).push(context),
                            )),
                        const Gap(16),
                        if (user?.uid != booking.userId &&
                            user?.role != UserRole.observer)
                          OutlinedButton(
                            onPressed: () async {
                              if (user?.uid != null) {
                                isJoined
                                    ? await participationFunction
                                        .removeParticipant()
                                    : await participationFunction
                                        .addParticipant();
                              }
                            },
                            child: Text(isJoined ? 'Leave' : 'Join'),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const Spacer(), // Pushes admin buttons to the bottom
              // Admin Actions
              if ((user?.uid == booking.userId) || user?.role == UserRole.admin)
                Row(
                  children: [
                    // Expanded(
                    //   child: ElevatedButton.icon(
                    //     icon: const Icon(Icons.edit),
                    //     onPressed: () => showDialog(
                    //       useRootNavigator: false,
                    //       context: context,
                    //       builder: (context) => BookingDialog(
                    //         bookingModel: booking,
                    //         context,
                    //       ),
                    //     ),
                    //     label: const Text('Edit'),
                    //   ),
                    // ),
                    const Gap(10),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.delete),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.error),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => ConfirmDialog(
                            confirmText: 'Delete',
                            cancelText: 'Cancel',
                            description:
                                'Are you sure you want to delete this booking?',
                            confirmAction: () {
                              context.pop();
                              ref
                                  .read(bookingRepositoryProvider)
                                  .deleteBooking(booking.id);
                              context.go('/'); // Go back to home after delete
                            },
                            title: 'Delete Booking',
                          ),
                        ),
                        label: const Text('Delete'),
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
