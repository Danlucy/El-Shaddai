import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_shaddai/api/api_repository.dart';
import 'package:el_shaddai/api/models/access_token_model/access_token_model.dart';
import 'package:el_shaddai/features/booking/controller/booking_controller.dart';
import 'package:el_shaddai/features/booking/repository/booking_repository.dart';
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
  @override
  Widget build(BuildContext context) {
    ref.watch(accessTokenNotifierProvider);
    final apiRepository = ApiRepository();
    final bookingFunction = ref.watch(bookingControllerProvider.notifier);
    return ElevatedButton(
      onPressed: () async {
        String? web;
        try {
          bookingFunction.isBookingDataInvalid(
            widget.formKey,
          );
          bookingFunction.isTimeRangeInvalid(context);

          if (ref.read(bookingVenueStateProvider) !=
              BookingVenueComponent.location) {
            await apiRepository
                .createMeeting(
              bookingFunction.getZoomMeetingModel(),
              ref.watch(accessTokenNotifierProvider).value!.token,
            )
                .then((value) {
              web = value.data['join_url'];
            });
          }
          ref.read(bookingRepositoryProvider).createBooking(
                model: bookingFunction.createBookingModel(web),
                call: widget.errorCall,
                recurrence: bookingFunction.getRecurrenceConfigurationModel(),
              );
          Navigator.pop(context);
        } on FirebaseException catch (e) {
          throw e.message!;
        } catch (e) {
          widget.errorCall(
              e.toString().contains('Null check operator used on a null value')
                  ? 'Booking Failed! Fill in all the Data. WTF $e'
                  : e.toString());
        }
      },
      child: const Text('Create Event'),
    );
  }
}
