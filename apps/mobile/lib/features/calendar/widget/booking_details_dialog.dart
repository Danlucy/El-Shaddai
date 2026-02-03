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
import 'package:mobile/core/widgets/glass_container.dart';
import 'package:mobile/core/widgets/snack_bar.dart';
import 'package:mobile/features/booking/controller/booking_clipboard.dart';
import 'package:mobile/features/booking/controller/booking_controller.dart';
import 'package:mobile/features/booking/presentations/booking_screen.dart';
import 'package:mobile/features/booking/state/booking_state.dart';
import 'package:mobile/features/booking/widgets/zoom_display_component.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:util/util.dart';

import '../../../core/router/router.dart';
import '../../../core/utility/url_launcher.dart';
import '../../../core/widgets/calendar_widget.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/widgets/confirm_button.dart';
import '../../auth/widgets/loader.dart';
import '../../booking/presentations/booking_dialog.dart';
import '../../booking/provider/booking_provider.dart';
import '../../participant/participant_controller/participant_controller.dart';

class BookingDetailsDialog extends ConsumerStatefulWidget {
  const BookingDetailsDialog({super.key, required this.bookingModel});

  final BookingModel bookingModel;

  @override
  ConsumerState createState() => _BookingDetailsDialogState();
}

class _BookingDetailsDialogState extends ConsumerState<BookingDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final textScaler = MediaQuery.textScalerOf(context).scale(1);

    return ref
        .watch(
          getSingleCurrentOrgBookingStreamProvider(
            bookingId: widget.bookingModel.id,
          ),
        )
        .when(
          data: (data) {
            final BookingModel booking = data ?? widget.bookingModel;

            final participationFunction = ref.watch(
              participantControllerProvider(booking.id).notifier,
            );
            final participantStream = ref
                .watch(participantRepositoryProvider)
                .getAllParticipants(booking.id);

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: EdgeInsets.zero,
                  child: FractionallySizedBox(
                    widthFactor:
                        (TextScaleFactor.oldMan ==
                            TextScaleFactor.scaleFactor(textScaler)
                        ? 0.95
                        : 0.92),
                    heightFactor: 0.95,
                    child: GlassmorphicContainer(
                      width: double.infinity,
                      height: double.infinity,
                      borderRadius: 20,
                      blur: 4,
                      border: 2,
                      linearGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.onSurface.withOpac(0.1),
                          Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpac(0.05),
                        ],
                        stops: const [0.1, 1],
                      ),
                      borderGradient: LinearGradient(
                        colors: [
                          Colors.white.withOpac(0.5),
                          Colors.white.withOpac(0.5),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {},
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(
                            left: 16,
                            top: 16,
                            right: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () {
                                      final stateToCopy = BookingState(
                                        title: booking.title,
                                        bookingId: null,
                                        hostId: user.value?.uid,
                                        password: booking.password,
                                        description: booking.description,
                                        location: booking.location,
                                        timeRange: booking.timeRange,
                                        recurrenceState:
                                            booking.recurrenceState,
                                        recurrenceFrequency:
                                            booking
                                                .recurrenceModel
                                                ?.recurrenceFrequency ??
                                            1,
                                        // ... map other fields
                                      );
                                      ref
                                          .read(
                                            bookingClipboardProvider.notifier,
                                          )
                                          .copy(stateToCopy);
                                      showSuccessfulSnackBar(
                                        context,
                                        'Booking Copied!',
                                      );
                                    },
                                    icon: const Icon(Icons.copy),
                                  ),
                                  if ((user.value.isHost(booking.userId)) ||
                                      user.value
                                          .currentRole(ref)
                                          .isWatchmanOrHigher)
                                    IconButton(
                                      padding: const EdgeInsets.all(0),

                                      onPressed: () {
                                        showDialog(
                                          useRootNavigator: false,
                                          context: context,
                                          builder: (context) => BookingDialog(
                                            bookingModel: booking,
                                            context,
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),

                                  if ((user.value.isHost(booking.userId)) ||
                                      user.value
                                          .currentRole(ref)
                                          .isWatchmanOrHigher)
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Scaffold(
                                            backgroundColor: Colors.transparent,
                                            body: Center(
                                              child: ConfirmButton(
                                                confirmText: 'Delete',
                                                cancelText: 'Cancel',
                                                description:
                                                    'Are you sure you want to delete this booking? This action cannot be reversed',
                                                confirmAction: () {
                                                  context.pop();
                                                  ref
                                                      .read(
                                                        bookingControllerProvider
                                                            .notifier,
                                                      )
                                                      .deleteBooking(
                                                        context,
                                                        booking,
                                                      );
                                                  context.pop();
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                ],
                              ),
                              AutoSizeText(
                                minFontSize: 15,
                                maxFontSize: 30,
                                maxLines: 1,
                                booking.title,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.inverseSurface,
                                ),
                              ),
                              Text(
                                booking.host,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        CalendarWidget(
                                          date: booking.timeRange.start,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          child: Text(
                                            DateFormat.jm().format(
                                              booking.timeRange.start,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.arrow_right_alt_outlined),
                                    Column(
                                      children: [
                                        CalendarWidget(
                                          date: booking.timeRange.end,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          child: Text(
                                            DateFormat.jm().format(
                                              booking.timeRange.end,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(16),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSecondary.withOpac(0.4),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 14,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: AlignmentGeometry.center,
                                        child: const Text(
                                          'The Prayer Altar Focus on',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Gap(2),
                                      Text(
                                        booking.description,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Gap(16),
                              if (booking.location.address != null)
                                Row(
                                  children: [
                                    const Icon(Icons.location_on),
                                    const Gap(5),
                                    Expanded(
                                      child: Text(
                                        booking.location.address.toString(),
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (booking.location.chords != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 250,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                      child: GoogleMap(
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
                                ),
                              if (booking.location.web != null &&
                                  user.value?.currentRole(ref) !=
                                      UserRole.observer)
                                _ZoomComponent(
                                  user: user,
                                  ref: ref,
                                  booking: booking,
                                ),

                              if (user.value?.currentRole(ref) ==
                                  UserRole.observer)
                                Text(
                                  'You can only see the Zoom orAddress details if you are accepted as an intercessor.\nPlease go to the About Us page ans contact the admin.',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              const SizedBox(height: 16),
                              _participantComponent(
                                participantStream,
                                user,
                                booking,
                                participationFunction,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          error: (error, stack) => const Center(child: Text('Error')),
          loading: () => const Loader(),
        );
  }

  StreamBuilder<List<UserModel>> _participantComponent(
    Stream<List<UserModel>> participantStream,
    AsyncValue<UserModel?> user,
    BookingModel booking,
    ParticipantController participationFunction,
  ) {
    return StreamBuilder<List<UserModel>>(
      stream: participantStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final participants = snapshot.data ?? [];
        final bool isJoined = participants.any(
          (userModel) => userModel.uid == user.value?.uid,
        );

        return Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              if (participants.isEmpty)
                IntrinsicHeight(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 200,
                      minHeight: 40,
                      maxWidth: 300,
                    ),
                    child: GlassContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            const Center(
                              child: Text(
                                'No Intercessors',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              if (participants.isNotEmpty)
                AnimatedSize(
                  alignment: Alignment.topCenter,
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 300),

                  child: IntrinsicHeight(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 200,
                        minHeight: 40,
                      ),
                      child: GlassContainer(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                vertical: 8,
                              ),
                              child: Text(
                                'Intercessors',
                                style: TextStyle(
                                  color: context.colors.secondary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...participants.map(
                              (UserModel userModel) => GestureDetector(
                                onTap: () =>
                                    ProfileRoute(userModel).push(context),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    userModel.name,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              if ((user.value?.uid == booking.userId) ||
                  user.value?.currentRole(ref) == UserRole.admin)
                joinButton(
                  user.value,
                  isJoined,
                  participationFunction,
                  context,
                ),
              const Gap(10),
            ],
          ),
        );
      },
    );
  }

  ElevatedButton joinButton(
    UserModel? user,
    bool isJoined,
    ParticipantController participationFunction,
    BuildContext context,
  ) {
    return ElevatedButton(
      onPressed: () async {
        if (user?.uid != null) {
          try {
            if (isJoined) {
              await participationFunction.removeParticipant();
            } else {
              await participationFunction.addParticipant();
            }
          } catch (e) {
            showFailureSnackBar(context, e.toString());
          }
        } else {
          showFailureSnackBar(
            context,
            'User unavailable, check Internet connection',
          );
        }
      },
      child: Text(isJoined ? 'Leave' : 'Join'),
    );
  }
}

class _ZoomComponent extends StatelessWidget {
  const _ZoomComponent({
    required this.user,
    required this.ref,
    required this.booking,
  });

  final AsyncValue<UserModel?> user;
  final WidgetRef ref;
  final BookingModel booking;

  void joinMeeting() {
    if (user.value?.currentRole(ref) == UserRole.observer) return;
    launchURL(booking.location.web!);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: joinMeeting,
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            radius: 20,
            backgroundImage: const AssetImage('assets/zoom.png'),
          ),
        ),
        const Gap(5),
        GestureDetector(
          onTap: () {
            user.value?.uid == booking.userId
                ? Clipboard.setData(
                    ClipboardData(text: booking.location.meetingID()),
                  )
                : joinMeeting();
          },
          child: Text(
            user.value?.uid == booking.userId
                ? "Click to Copy Zoom ID"
                : "Click to Join Meeting",
          ),
        ),
        const Spacer(),
        if (user.value?.uid == booking.userId)
          IconButton(
            onPressed: () {
              if (user.value?.currentRole(ref) == UserRole.observer) return;
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) => AlertDialog(
                  backgroundColor: Colors.transparent,
                  contentPadding: EdgeInsets.zero,
                  content: GlassmorphismPasswordDialog(
                    initialPassword: booking.password,
                    isDisplay: true,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.key),
          ),
      ],
    );
  }
}
