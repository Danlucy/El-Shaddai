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
    this.bookingId,
    required this.isUpdating,
  });

  final GlobalKey<FormState> formKey;
  final void Function(String) errorCall;
  final bool isUpdating;
  final String? bookingId;

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
          bookingFunction.isTimeRangeInvalid(
              context, widget.isUpdating, widget.bookingId);
          if (ref.read(bookingVenueStateProvider) !=
              BookingVenueComponent.location) {
            // change3
            // await apiRepository
            //     .createMeeting(
            //   bookingFunction.instantiateZoomMeetingModel(),
            //   ref.watch(accessTokenNotifierProvider).value!.token,
            // )
            //     .then((value) {
            //   web = value.data['join_url'];
            // });
          }

          ref.read(bookingRepositoryProvider).createOrEditBooking(
                bookingModel: bookingFunction.instantiateBookingModel(
                    'https://us02web.zoom.us/j/3128833664?pwd=joy'),
                //change4
                // bookingModel: bookingFunction.instantiateBookingModel(web),
                call: widget.errorCall,
                bookingId: widget.bookingId,
                recurrence:
                    bookingFunction.instantiateRecurrenceConfigurationModel(),
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
      child: Text(
          widget.isUpdating ? 'Update Prayer Watch' : 'Create Prayer Watch'),
    );
  }
}
