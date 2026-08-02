import 'package:api/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:website/core/utility/url_launch.dart';

import '../controller/booking_controller.dart';
import '../provider/booking_provider.dart';
import '../provider/booking_submission_provider.dart';

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
    List<dynamic>? occurrenceIds;
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          String? web = ref.read(bookingControllerProvider).location?.web;
          try {
            bookingFunction.isBookingDataInvalid(widget.formKey);
            bookingFunction.isTimeRangeInvalid(
              context,
              widget.isUpdating,
              bookingReader.bookingId,
              checkCachedOverlap: false,
            );
            if (ref.read(bookingVenueStateProvider) !=
                BookingVenueComponent.location) {
              if (parseZoomId(web).isEmpty) {
                await apiRepository
                    .createMeeting(
                      bookingFunction.instantiateZoomMeetingModel(),
                    )
                    .then((value) {
                      bookingFunction.setWeb(value.data['join_url']);
                      bookingFunction.setPassword(value.data['password']);
                      occurrenceIds = value.data['occurrences'];
                    });
              } else {}
            }

            final repository = ref.read(currentOrgRepositoryProvider);
            ref
                .read(bookingSubmissionProvider.notifier)
                .submit(
                  bookingFunction.instantiateBookingDTO(
                    organizationId: repository.organizationId,
                    isUpdating: widget.isUpdating,
                    zoomOccurrences: occurrenceIds,
                  ),
                );

            if (context.mounted) {
              Navigator.pop(context);
            }
          } on FirebaseException catch (e) {
            widget.errorCall(
              e.message ??
                  'Booking failed because Firebase could not be reached.',
            );
          } catch (e) {
            widget.errorCall(
              e.toString().contains('Null check operator used on a null value')
                  ? 'Booking Failed! Fill in all the Data. ? $e'
                  : e.toString(),
            );
          }
        },
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 15),

          child: Text(
            style: TextStyle(fontSize: 24),
            widget.isUpdating ? 'Update Prayer Watch' : 'Create Prayer Watch',
          ),
        ),
      ),
    );
  }
}
