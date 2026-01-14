import 'package:auto_size_text/auto_size_text.dart';
import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/widgets/glass_container.dart';
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
    final user = ref.watch(
      userProvider,
    ); // ✅ Ensure UI updates when user changes
    return ref
        .watch(
          getSingleCurrentOrgBookingStreamProvider(
            bookingId: widget.bookingModel.id,
          ),
        )
        .when(
          data: (data) {
            final BookingModel booking =
                data ?? widget.bookingModel; // Use latest value if available

            final participationFunction = ref.watch(
              participantControllerProvider(booking.id).notifier,
            );
            final participantStream = ref
                .watch(participantRepositoryProvider)
                .getAllParticipants(booking.id);

            return Padding(
              padding: EdgeInsetsGeometry.all(5),
              child: Dialog(
                insetPadding: EdgeInsets.zero,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.secondaryContainer,
                child: FractionallySizedBox(
                  heightFactor: 0.95,
                  widthFactor: 0.95,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                minFontSize: 15, // Minimum font size
                                maxFontSize: 30,
                                maxLines: 1,
                                booking.title, // ✅ Uses updated booking data
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.inverseSurface,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  context.pop();
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          booking.host, // ✅ Uses updated booking data
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
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
                        // FIX: Padding for the description container
                        Text('   The Prayer Altar Focus on'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                              vertical: 4,
                              horizontal: 14,
                            ),
                            child: Text(
                              booking.description,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
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
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: SizedBox(
                              width: 300,
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
                            user.value?.currentRole(ref) != UserRole.observer)
                          _ZoomComponent(user: user, ref: ref, booking: booking)
                        else
                          Text(
                            'Reach out to About Us page for details on joining this booking.',
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
            );
          },
          error: (error, stack) {
            return const Center(child: Text('Error'));
          },
          loading: () => const Loader(),
        ); // Get the organization ID from the provider
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
                    // FIX: Added horizontal padding to the GlassContainer
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
                            if (user.value?.uid != booking.userId &&
                                user.value?.currentRole(ref) !=
                                    UserRole.observer)
                              joinButton(
                                user.value,
                                isJoined,
                                participationFunction,
                                context,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              if (participants.isNotEmpty)
                IntrinsicHeight(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 200,
                      minHeight: 40,
                    ),
                    // FIX: Added horizontal padding to the GlassContainer
                    child: GlassContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          const Text(
                            'Intercessors',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...participants.map(
                            (UserModel userModel) => GestureDetector(
                              onTap: () {
                                ProfileRoute(userModel).push(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: Text(
                                  userModel.name,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                          if (user.value?.uid != booking.userId &&
                              user.value?.currentRole(ref) != UserRole.observer)
                            joinButton(
                              user.value,
                              isJoined,
                              participationFunction,
                              context,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              if ((user.value?.uid == booking.userId) ||
                  user.value?.currentRole(ref) == UserRole.admin)
                Row(
                  children: [
                    editButton(context, booking),
                    const Gap(10),
                    deleteButton(context, booking),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Expanded editButton(BuildContext context, BookingModel booking) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            useRootNavigator: false,
            context: context,
            builder: (context) {
              Future(() {});
              return BookingDialog(
                bookingModel: booking, // ✅ Uses updated booking
                context,
              );
            },
          );
        },
        child: const Text('Edit'),
      ),
    );
  }

  Expanded deleteButton(BuildContext context, BookingModel booking) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return ConfirmButton(
                confirmText: 'Delete ',
                cancelText: 'Cancel',
                description:
                    'Are you sure you want to delete this booking? This action cannot be reversed',
                confirmAction: () {
                  context.pop();

                  ref
                      .read(currentOrgRepositoryProvider)
                      .deleteBooking(booking.id);
                  context.pop();
                },
              );
            },
          );
        },
        child: const Text('Delete'),
      ),
    );
  }

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
    super.key,
    required this.user,
    required this.ref,
    required this.booking,
  });

  final AsyncValue<UserModel?> user;
  final WidgetRef ref;
  final BookingModel booking;
  void joinMeeting() {
    if (user.value?.currentRole(ref) == UserRole.observer) {
      return;
    }
    launchURL(booking.location.web!);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            joinMeeting();
          },
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
              if (user.value?.currentRole(ref) == UserRole.observer) {
                return;
              }

              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    backgroundColor: Colors.transparent,
                    contentPadding: EdgeInsets.zero,
                    content: GlassmorphismPasswordDialog(
                      initialPassword: booking.password,
                      isDisplay: true,
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.key),
          ),
      ],
    );
  }
}
