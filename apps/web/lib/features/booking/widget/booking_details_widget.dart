import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:util/util.dart';
import 'package:website/core/utility/launch_google_map.dart';
import 'package:website/core/utility/utility.dart';
import 'package:website/core/widgets/calendar_widget.dart';
import 'package:website/core/widgets/confirm_button.dart';
import 'package:website/core/widgets/glass_button.dart';
import 'package:website/core/widgets/loader.dart';
import 'package:website/features/auth/controller/auth_controller.dart';
import 'package:website/features/participant/controller/participant_controller.dart';

import '../provider/booking_provider.dart';

/// A widget that displays the core content for a booking's details.
class BookingDetailsContent extends ConsumerStatefulWidget {
  const BookingDetailsContent({super.key, required this.booking});

  final BookingModel booking;

  @override
  ConsumerState<BookingDetailsContent> createState() =>
      _BookingDetailsContentState();
}

class _BookingDetailsContentState extends ConsumerState<BookingDetailsContent> {
  @override
  Widget build(BuildContext context) {
    final user = ProviderScope.containerOf(
      context,
      listen: false,
    ).read(userProvider);
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    // 1. We use a Stack to separate the Glass Background from the Content
    // This allows the content to determine the height naturally.
    return Stack(
      children: [
        // A. Glass Background (Stretches to fill the stack)
        Positioned.fill(
          child: GlassmorphicContainer(
            width: double.infinity,
            height: double.infinity,
            borderRadius: 20,
            blur: 15,
            border: 2,
            linearGradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.surface.withOpacity(0.1),
                Theme.of(context).colorScheme.surface.withOpacity(0.05),
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
          ),
        ),

        // B. Actual Content
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: ResponsiveRowColumn(
            layout: isDesktop
                ? ResponsiveRowColumnType.ROW
                : ResponsiveRowColumnType.COLUMN,
            rowCrossAxisAlignment: CrossAxisAlignment.start,
            rowSpacing: 40,
            columnSpacing: 20,
            children: [
              // 1. Left/Top Column: Main Details
              ResponsiveRowColumnItem(
                rowFlex: 2,
                child: _MainDetailsColumn(booking: widget.booking),
              ),

              // 2. Right/Bottom Column: Participants
              ResponsiveRowColumnItem(
                rowFlex: 1,
                // IntrinsicHeight ensures the glass container wraps the content snugly
                child: IntrinsicHeight(
                  child: Stack(
                    children: [
                      // Inner Glass Background
                      Positioned.fill(
                        child: GlassmorphicContainer(
                          width: double.infinity,
                          height: double.infinity,
                          borderRadius: 20,
                          blur: 15,
                          border: 2,
                          linearGradient: _glassBg(context),
                          borderGradient: _glassBorder(),
                        ),
                      ),
                      // Inner Content
                      _ParticipantsAndActionsColumn(
                        booking: widget.booking,
                        user: user.value,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  LinearGradient _glassBg(BuildContext context) => LinearGradient(
    colors: [
      Theme.of(context).colorScheme.surface.withOpacity(0.1),
      Theme.of(context).colorScheme.surface.withOpacity(0.05),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  LinearGradient _glassBorder() => LinearGradient(
    colors: [Colors.white.withOpacity(0.8), Colors.white.withOpacity(0.1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// -----------------------------------------------------------------------------
// HELPER WIDGETS
// -----------------------------------------------------------------------------

class _MainDetailsColumn extends StatelessWidget {
  const _MainDetailsColumn({required this.booking});
  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
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
                  color: Theme.of(context).colorScheme.primary,
                ),
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
                  color: Theme.of(context).colorScheme.primary,
                ),
                const Gap(4),
                Text(DateFormat.jm().format(booking.timeRange.end)),
              ],
            ),
          ],
        ),
        const Gap(24),
        // Description
        Text(
          'The Prayer Altar Focus on',
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
          Text('Location', style: Theme.of(context).textTheme.titleMedium),
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
          Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 250),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: GoogleMap(
                    zoomGesturesEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: booking.location.chords!,
                      zoom: 13,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId("1"),
                        position: booking.location.chords!,
                      ),
                    },
                  ),
                ),
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      booking.location.chords?.openInGoogleMaps();
                    },
                    child: Image.asset(
                      'assets/google_map.png',
                      height: 60,
                      width: 100,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      booking.location.chords?.openInWaze();
                    },
                    child: Image.asset(
                      'assets/waze_logo.png',
                      height: 60,
                      width: 100,
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}

class _ParticipantsAndActionsColumn extends ConsumerWidget {
  const _ParticipantsAndActionsColumn({required this.booking, this.user});
  final BookingModel booking;
  final UserModel? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participantStream = ref
        .watch(participantRepositoryProvider)
        .getAllParticipants(booking.id);
    final participationFunction = ref.watch(
      participantControllerProvider(booking.id).notifier,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Shrink to fit content
        children: [
          // --- Meeting Info ---
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
                      Clipboard.setData(ClipboardData(text: booking.password!));
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
                      Clipboard.setData(
                        ClipboardData(text: booking.location.meetingID()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Meeting ID copied to clipboard'),
                        ),
                      );
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
                      builder: (context) => Dialog(
                        // Inner dialog reusing stack strategy for glass
                        child: SizedBox(
                          width: 350,
                          height: 60,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: GlassmorphicContainer(
                                  width: double.infinity,
                                  height: double.infinity,
                                  borderRadius: 16,
                                  blur: 10,
                                  border: 1,
                                  linearGradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.1),
                                    ],
                                  ),
                                  borderGradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withOpacity(0.5),
                                      Colors.white.withOpacity(0.5),
                                    ],
                                  ),
                                ),
                              ),
                              Center(
                                child: SelectableText(
                                  booking.password ?? 'No Password',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const Gap(16),
          ],

          // --- Participants Header ---
          Text('Intercessors', style: Theme.of(context).textTheme.titleMedium),
          const Gap(8),

          // --- Participants List ---
          StreamBuilder<List<UserModel>>(
            stream: participantStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }

              final participants = snapshot.data ?? [];
              final bool isJoined = participants.any(
                (userModel) => userModel.uid == user?.uid,
              );

              return Column(
                children: [
                  if (participants.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No intercessors yet.'),
                    )
                  else
                    // ListView inside a Column requires shrinkWrap + physics physics
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: participants.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      itemBuilder: (context, index) {
                        final userModel = participants[index];
                        return ListTile(
                          title: Text(userModel.name),
                          onTap: () {},
                        );
                      },
                    ),

                  const SizedBox(height: 16),

                  // Join/Leave Button
                  if (user?.uid != booking.userId &&
                      user?.currentRole(ref) != UserRole.observer &&
                      user != null)
                    joinButton(user, isJoined, participationFunction, context),
                ],
              );
            },
          ),

          // --- Admin Actions ---
          if ((user?.uid == booking.userId) ||
              user?.currentRole(ref) == UserRole.admin)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: GlassmorphicButton(
                      backgroundColors: [
                        Theme.of(
                          context,
                        ).colorScheme.errorContainer.withOpacity(0.12),
                        Theme.of(
                          context,
                        ).colorScheme.errorContainer.withOpacity(0.2),
                      ],
                      borderRadius: 20,
                      text: 'Delete',
                      icon: Icons.delete,
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
                                .read(currentOrgRepositoryProvider)
                                .deleteBooking(booking.id);
                            context.pop();
                          },
                          title: 'Delete Booking',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// Reusable Join Button Function
OutlinedButton joinButton(
  UserModel? user,
  bool isJoined,
  ParticipantController participationFunction,
  BuildContext context,
) {
  return OutlinedButton(
    onPressed: () async {
      if (user?.uid != null) {
        try {
          if (isJoined) {
            await participationFunction.removeParticipant();
          } else {
            await participationFunction.addParticipant();
          }
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User unavailable, check Internet connection"),
          ),
        );
      }
    },
    child: Text(isJoined ? 'Leave' : 'Join'),
  );
}
