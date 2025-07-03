import 'package:auto_size_text/auto_size_text.dart';
import 'package:constants/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../core/router/router.dart';
import '../../../core/utility/url_launcher.dart';
import '../../../core/widgets/calendar_widget.dart';
import '../../../models/booking_model/booking_model.dart';
import '../../../models/user_model/user_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/widgets/confirm_button.dart';
import '../../booking/controller/booking_controller.dart';
import '../../booking/presentations/booking_dialog.dart';
import '../../booking/repository/booking_repository.dart';
import '../../participant/participant_controller/participant_controller.dart';
import '../../participant/participant_repository/participant_repository.dart';

class BookingDetailsDialog extends ConsumerStatefulWidget {
  const BookingDetailsDialog({
    super.key,
    required this.bookingModel,
  });

  final BookingModel bookingModel;

  @override
  ConsumerState createState() => _BookingDetailsDialogState();
}

class _BookingDetailsDialogState extends ConsumerState<BookingDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    final user =
        ref.watch(userProvider); // ✅ Ensure UI updates when user changes

    // ✅ Watch Firestore for booking model updates (if applicable)
    final bookingProvider =
        ref.watch(bookingStreamProvider(bookingId: widget.bookingModel.id));
    final BookingModel booking = bookingProvider.value ??
        widget.bookingModel; // Use latest value if available

    final participationFunction =
        ref.read(participantControllerProvider(booking.id).notifier);
    final participantStream =
        ref.watch(participantRepositoryProvider).getAllParticipants(booking.id);

    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      content: Container(
        padding: EdgeInsets.zero,
        width: width * 0.8,
        height: height * 0.85,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AutoSizeText(
                      minFontSize: 15, // Minimum font size
                      maxFontSize: 30, maxLines: 1,
                      booking.title, // ✅ Uses updated booking data
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.inverseSurface),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          context.pop();
                        },
                        icon: const Icon(Icons.close)),
                  ),
                ],
              ),
              Text(
                booking.host, // ✅ Uses updated booking data
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.outline),
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
                            color: Theme.of(context).colorScheme.primary),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                              DateFormat.jm().format(booking.timeRange.start)),
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_right_alt_outlined),
                    Column(
                      children: [
                        CalendarWidget(
                            date: booking.timeRange.end,
                            color: Theme.of(context).colorScheme.primary),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                              DateFormat.jm().format(booking.timeRange.end)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Gap(16),
              Text(
                'Shalom ${user?.name ?? ''}, these are our prayer focus.',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const Gap(5),
              Container(
                decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.onSecondary.withOpac(0.4),
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
                child: Text(
                  booking.description,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
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
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
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
                      )),
                ),
              if (booking.location.web != null)
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // print('dad');
                        // print(booking.location.web!);
                        //change1
                        // launchURL(booking.location.web!);
                        launchURL(
                            'https://us02web.zoom.us/j/3128833664?pwd=joy');
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
                        Clipboard.setData(
                            ClipboardData(text: booking.location.meetingID()));
                      },
                      child: Text('3128833664'
                          //change2
                          // booking.location.meetingID(spaced: true),
                          ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),

              /// 📌 ✅ Only this section uses the StreamBuilder
              StreamBuilder<List<UserModel>>(
                stream: participantStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final participants = snapshot.data ?? [];
                  final bool isJoined = participants
                      .any((userModel) => userModel.uid == user?.uid);

                  return Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        if (participants.isEmpty)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpac(0.4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            constraints: const BoxConstraints(
                                minWidth: 200, minHeight: 40, maxWidth: 200),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  const Center(
                                    child: Text(
                                      'No Intercessors',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  if (user?.uid != booking.userId)
                                    joinButton(user, isJoined,
                                        participationFunction, context),
                                ],
                              ),
                            ),
                          ),
                        if (participants.isNotEmpty)
                          Container(
                            constraints: const BoxConstraints(
                                minWidth: 200, minHeight: 40),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpac(0.4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Intercessors',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                ...participants.map((UserModel userModel) =>
                                    GestureDetector(
                                      onTap: () {
                                        ProfileRoute(userModel).push(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: Text(
                                          userModel.name,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    )),
                                if (user?.uid != booking.userId)
                                  joinButton(user, isJoined,
                                      participationFunction, context),
                              ],
                            ),
                          ),
                        const SizedBox(height: 16),
                        if ((user?.uid == booking.userId) ||
                            user?.role == UserRole.admin)
                          Row(
                            children: [
                              editButton(
                                context,
                                booking,
                              ),
                              const Gap(10),
                              deleteButton(context, booking)
                            ],
                          )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
    );
  }

  Expanded editButton(
    BuildContext context,
    BookingModel booking,
  ) {
    return Expanded(
      child: ElevatedButton(
          onPressed: () {
            showDialog(
                useRootNavigator: false,
                context: context,
                builder: (context) {
                  Future(() {
                    ref
                        .read(bookingControllerProvider.notifier)
                        .setState(booking);
                    ref
                        .read(bookingVenueStateProvider.notifier)
                        .switchVenue(booking);
                  });
                  return BookingDialog(
                    bookingModel: booking, // ✅ Uses updated booking
                    context,
                  );
                });
          },
          child: const Text('Edit')),
    );
  }

  Expanded deleteButton(
    BuildContext context,
    BookingModel booking,
  ) {
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
                            .read(bookingRepositoryProvider)
                            .deleteBooking(booking.id);
                        context.pop();
                      });
                });
          },
          child: const Text('Delete')),
    );
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
}
