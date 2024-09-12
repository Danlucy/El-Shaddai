import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_shaddai/api/models/zoom_meeting_model/zoom_meeting_model.dart';
import 'package:el_shaddai/features/auth/controller/auth_controller.dart';
import 'package:el_shaddai/features/booking/controller/booking_controller.dart';
import 'package:el_shaddai/features/booking/repository/booking_repository.dart';
import 'package:el_shaddai/features/booking/state/booking_state.dart';
import 'package:el_shaddai/models/booking_model/booking_model.dart';
import 'package:el_shaddai/models/location_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookButton extends ConsumerStatefulWidget {
  const BookButton({
    super.key,
    required this.formKey,
    required this.errorCall,
  });
  final GlobalKey<FormState> formKey;
  final void Function(String) errorCall;
  @override
  ConsumerState createState() => _BookButtonState();
}

class _BookButtonState extends ConsumerState<BookButton> {
  _BookButtonState();
  @override
  Widget build(BuildContext context) {
    final bookingReader = ref.watch(bookingControllerProvider);
    return ElevatedButton(
        onPressed: () {
          try {
            final valid = widget.formKey.currentState?.validate() ?? false;
            if (!valid) return;
            final title = bookingReader.title;
            final timeRange = bookingReader.timeRange;
            final location = bookingReader.location;
            final description = bookingReader.description;

            final user = ref.read(userProvider);
            print('$title $timeRange $location $description $user');
            if (title == null ||
                timeRange == null ||
                (location == null) ||
                description == null ||
                user == null) {
              widget.errorCall('Booking Failed! Fill in all the Data.');
              return;
            }
            int zoomMeetingType = 8;
            if (bookingReader.recurrenceState == RecurrenceState.none) {
              zoomMeetingType = 2;
            }

            ZoomMeetingModel model = ZoomMeetingModel(
              topic: bookingReader.title,
              description: bookingReader.description,
              startTime: bookingReader.timeRange!.start,
              type: zoomMeetingType,
            );
            BookingModel bookingModel = BookingModel(
                title: title,
                hostId: user.uid,
                timeRange: timeRange,
                userId: user.uid,
                id: FirebaseFirestore.instance.collection('dog').doc().id,
                location: LocationData(
                    chords: location?.chords,
                    address: location?.address ?? 'ZoomUrl'),
                description: description);
            print(model);
            print(location);
            print(bookingModel.location.address);
            print(bookingModel.location.chords);

            // ref.read(bookingRepositoryProvider).createBooking(bookingModel,
            //     (data) {
            //   widget.errorCall(data);
            // });
            // Navigator.pop(context);
          } on FirebaseException catch (e) {
            throw e.message!;
          } catch (e) {
            Navigator.pop(context);
            if (e
                .toString()
                .contains('Null check operator used on a null value')) {
              widget.errorCall('Booking Failed! Fill in all the Data.');
            } else {
              widget.errorCall(e.toString());
            }
          }
        },
        child: const Text('Create Event'));
  }
}
