import 'package:api/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/utility/url_launcher.dart';

import '../controller/booking_controller.dart';
import '../provider/booking_provider.dart';

class BookButton extends ConsumerStatefulWidget {
  const BookButton({
    super.key,
    required this.formKey,
    required this.errorCall,
    required this.isUpdating,
  });

  final GlobalKey<FormState> formKey;
  final void Function(String) errorCall;
  final bool isUpdating;

  @override
  ConsumerState createState() => _BookButtonState();
}

class _BookButtonState extends ConsumerState<BookButton> {
  @override
  Widget build(BuildContext context) {
    ref.watch(accessTokenNotifierProvider);
    final apiRepository = ApiRepository();
    final bookingFunction = ref.watch(bookingControllerProvider.notifier);
    final bookingReader = ref.watch(bookingControllerProvider);
    return ElevatedButton(
      onPressed: () async {
        String? web = ref.read(bookingControllerProvider).location?.web;
        try {
          bookingFunction.isBookingDataInvalid(widget.formKey);
          bookingFunction.isTimeRangeInvalid(
            context,
            widget.isUpdating,
            bookingReader.bookingId,
          );
          if (ref.read(bookingVenueStateProvider) !=
              BookingVenueComponent.location) {
            // change3
            if (parseZoomId(web).isEmpty) {
              await apiRepository
                  .createMeeting(
                    bookingFunction.instantiateZoomMeetingModel(),
                    ref.watch(accessTokenNotifierProvider).value!.token,
                  )
                  .then((value) {
                    bookingFunction.setWeb(value.data['join_url']);
                    bookingFunction.setPassword(value.data['password']);
                  });
            } else {}
          }

          ref
              .read(currentOrgRepositoryProvider)
              .createOrEditBooking(
                // bookingModel: bookingFunction.instantiateBookingModel(
                //     'https://us02web.zoom.us/j/3128833664?pwd=joy'),
                //change4
                bookingModel: bookingFunction.instantiateBookingModel(web),
                bookingId: bookingReader.bookingId,
                call: widget.errorCall,
                recurrence: bookingFunction
                    .instantiateRecurrenceConfigurationModel(),
              );

          Navigator.pop(context);
        } on FirebaseException catch (e) {
          throw e.message!;
        } catch (e) {
          widget.errorCall(
            e.toString().contains('Null check operator used on a null value')
                ? 'Booking Failed! Fill in all the Data. ? $e'
                : e.toString(),
          );
        }
      },
      child: Text(
        widget.isUpdating ? 'Update Prayer Watch' : 'Create Prayer Watch',
      ),
    );
  }
}
