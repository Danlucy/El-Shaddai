import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/core/utility/url_launcher.dart';
import 'package:el_shaddai/core/widgets/calendar_widget.dart';
import 'package:el_shaddai/features/auth/controller/auth_controller.dart';
import 'package:el_shaddai/features/booking/presentations/booking_screen.dart';
import 'package:el_shaddai/features/participant/participant_controller/participant_controller.dart';
import 'package:el_shaddai/features/participant/participant_repository/participant_repository.dart';
import 'package:el_shaddai/features/participant/presentation/widgets/join_button.dart';
import 'package:el_shaddai/models/booking_model/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

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
  Widget build(
    BuildContext context,
  ) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final textScaleFactor = TextScaleFactor.scaleFactor(textScale);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final user = ref.read(userProvider);
    final participantRepositary = ref
        .watch(participantRepositoryProvider)
        .getAllParticipants(widget.bookingModel.id);
    print(participantRepositary);
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      content: Container(
        padding: EdgeInsets.zero,
        width: width * 0.8,
        height: height * 0.85,
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              widget.bookingModel.title,
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.inverseSurface),
            ),
            Text(
              widget.bookingModel.host,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
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
                          date: widget.bookingModel.timeRange.start,
                          color: Theme.of(context).colorScheme.primary),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(DateFormat.jm()
                            .format(widget.bookingModel.timeRange.start)),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_right_alt_outlined),
                  Column(
                    children: [
                      CalendarWidget(
                          date: widget.bookingModel.timeRange.end,
                          color: Theme.of(context).colorScheme.primary),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(DateFormat.jm()
                            .format(widget.bookingModel.timeRange.end)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(16),
            Text(
              'Shalom ${user?.name ?? ''}, these are our prayer focus.',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const Gap(5),
            Container(
              decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.onSecondary.withOpac(0.4),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
              child: Text(
                widget.bookingModel.description,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ),
            const Gap(16),
            if (widget.bookingModel.location.address != null)
              Row(
                children: [
                  const Icon(Icons.location_on),
                  const Gap(5),
                  Expanded(
                    child: Text(
                      widget.bookingModel.location.address.toString(),
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 12,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            if (widget.bookingModel.location.chords != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SizedBox(
                    width: 300,
                    height: 250,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: widget.bookingModel.location.chords!,
                          zoom: 13,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId("1"),
                            position: widget.bookingModel.location.chords!,
                          )
                        },
                      ),
                    )),
              ),
            if (widget.bookingModel.location.web != null)
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      launchURL(widget.bookingModel.location.web!);
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
                      Clipboard.setData(ClipboardData(
                          text: widget.bookingModel.location.meetingID()));
                    },
                    child: Text(
                      widget.bookingModel.location.meetingID(spaced: true),
                    ),
                  ),
                ],
              ),
            StreamBuilder(
                stream: participantRepositary,
                builder: (context, snapshot) {
                  print(snapshot.data);
                  return snapshot.connectionState == ConnectionState.waiting
                      ? const CircularProgressIndicator()
                      : snapshot.data == null
                          ? const Text('No Participants')
                          : Text('Participants: ${snapshot.data?.length}');
                }),
            JoinButton(bookingId: widget.bookingModel.id),
          ]),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
    );
  }
}
