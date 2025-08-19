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
import 'package:website/core/widgets/calendar_widget.dart';
import 'package:website/core/widgets/confirm_button.dart';
import 'package:website/core/widgets/glass_button.dart';
import 'package:website/core/widgets/loader.dart';
import 'package:website/features/auth/controller/auth_controller.dart';
import 'package:website/features/participant/controller/participant_controller.dart';

/// A widget that displays the core content for a booking's details.
/// This is designed to be embedded in other screens.
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
    final user =
        ProviderScope.containerOf(context, listen: false).read(userProvider);
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return GlassmorphicContainer(
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
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ResponsiveRowColumn(
          layout: isDesktop
              ? ResponsiveRowColumnType.ROW
              : ResponsiveRowColumnType.COLUMN,
          rowCrossAxisAlignment: CrossAxisAlignment.start,
          rowSpacing: 40,
          columnSpacing: 20,
          children: [
            ResponsiveRowColumnItem(
              rowFlex: 2,
              child: _MainDetailsColumn(booking: widget.booking),
            ),
            ResponsiveRowColumnItem(
              rowFlex: 1,
              child: isDesktop
                  ? GlassmorphicContainer(
                      width: double.infinity,
                      height: double.infinity, // fill row height
                      borderRadius: 20,
                      blur: 15,
                      border: 2,
                      linearGradient: _glassBg(context),
                      borderGradient: _glassBorder(),
                      child: _ParticipantsAndActionsColumn(
                        booking: widget.booking,
                        user: user,
                      ),
                    )
                  : IntrinsicHeight(
                      // shrink wrap on mobile
                      child: GlassmorphicContainer(
                        width: double.infinity,
                        height: double
                            .infinity, // still required, but IntrinsicHeight will shrink it
                        borderRadius: 20,
                        blur: 15,
                        border: 2,
                        linearGradient: _glassBg(context),
                        borderGradient: _glassBorder(),
                        child: _ParticipantsAndActionsColumn(
                          booking: widget.booking,
                          user: user,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
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
        colors: [
          Colors.white.withOpacity(0.8),
          Colors.white.withOpacity(0.1),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}

// Helper Widget for the main details column
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

    return GlassmorphicContainer(
      width: double.infinity,
      height: double.infinity,
      borderRadius: 16,
      blur: 20,
      alignment: Alignment.center,
      border: 0,
      // 🔥 your original gradients unchanged
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Column(
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
                        Clipboard.setData(
                            ClipboardData(text: booking.location.meetingID()));
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Meeting ID copied to clipboard')));
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
                          child: GlassmorphicContainer(
                              linearGradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpac(0.2),
                                  Colors.white.withOpac(0.1),
                                ],
                                stops: const [0.1, 1.0],
                              ),
                              borderGradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpac(0.5),
                                  Colors.white.withOpac(0.5),
                                ],
                              ),
                              width: 350,
                              height: 60,
                              borderRadius: 16, // 👈 use param
                              blur: 10,
                              border: 1,
                              child: Center(
                                child: SelectableText(
                                    booking.password ?? 'No Password'),
                              )),
                        ),
                      ),
                    ),
                ],
              ),
            ],

            // --- Participants Header ---
            Text(
              'Intercessors',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Gap(8),

            // --- Scrollable Participants List ---
            Expanded(
              child: StreamBuilder<List<UserModel>>(
                stream: participantStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loader();
                  }

                  final participants = snapshot.data ?? [];

                  final bool isJoined = participants
                      .any((userModel) => userModel.uid == user?.uid);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        if (participants.isEmpty)
                          const Center(child: Text('No intercessors yet.'))
                        else
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

                        // ✅ Join button at the bottom of the list
                        if (user?.uid != booking.userId &&
                            user?.role != UserRole.observer &&
                            user != null)
                          joinButton(
                              user, isJoined, participationFunction, context),
                      ],
                    ),
                  );
                },
              ),
            ),

            // --- Admin Actions ---
            if ((user?.uid == booking.userId) || user?.role == UserRole.admin)
              Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: GlassmorphicButton(
                        backgroundColors: [
                          context.colors.errorContainer.withOpac(0.12),
                          context.colors.errorContainer.withOpac(0.2),
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
                                  .read(bookingRepositoryProvider)
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
      ),
    );
  }
}

OutlinedButton joinButton(UserModel? user, bool isJoined,
    ParticipantController participationFunction, BuildContext context) {
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("User unavailable, check Internet connection")),
        );
      }
    },
    child: Text(isJoined ? 'Leave' : 'Join'),
  );
}
