import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_shaddai/api/api_repository.dart';
import 'package:el_shaddai/api/models/access_token_model/access_token_model.dart';
import 'package:el_shaddai/api/models/recurrence_configuration_model/recurrence_configuration_model.dart';
import 'package:el_shaddai/api/models/zoom_meeting_model/zoom_meeting_model.dart';
import 'package:el_shaddai/core/utility/date_time_range.dart';
import 'package:el_shaddai/features/auth/controller/auth_controller.dart';
import 'package:el_shaddai/features/booking/controller/booking_controller.dart';
import 'package:el_shaddai/features/booking/repository/booking_repository.dart';
import 'package:el_shaddai/features/booking/state/booking_state.dart';
import 'package:el_shaddai/models/booking_model/booking_model.dart';
import 'package:el_shaddai/models/location_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_shaddai/api/api_repository.dart';
import 'package:el_shaddai/api/models/access_token_model/access_token_model.dart';
import 'package:el_shaddai/api/models/recurrence_configuration_model/recurrence_configuration_model.dart';
import 'package:el_shaddai/api/models/zoom_meeting_model/zoom_meeting_model.dart';
import 'package:el_shaddai/core/utility/date_time_range.dart';
import 'package:el_shaddai/features/auth/controller/auth_controller.dart';
import 'package:el_shaddai/features/booking/controller/booking_controller.dart';
import 'package:el_shaddai/features/booking/repository/booking_repository.dart';
import 'package:el_shaddai/features/booking/state/booking_state.dart';
import 'package:el_shaddai/models/booking_model/booking_model.dart';
import 'package:el_shaddai/models/location_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final bookingReader = ref.watch(bookingControllerProvider);
    final apiRepository = ApiRepository();
    final bookingFunction = ref.watch(bookingControllerProvider.notifier);
    return ElevatedButton(
      onPressed: () {
        try {
          if (!(widget.formKey.currentState?.validate() ?? false)) return;

          if (bookingFunction.isBookingDataValid(
              widget.formKey, widget.errorCall)) {
            widget.errorCall('Booking Failed! Fill in all the Data.');
            return;
          }

          final zoomMeetingType = bookingFunction.getZoomMeetingType();
          final recurrenceConfigurationModel = ref
              .read(bookingControllerProvider.notifier)
              .getRecurrenceConfigurationModel();

          final zoomMeetingModel = ZoomMeetingModel(
            topic: bookingReader.title,
            description: bookingReader.description,
            startTime: bookingReader.timeRange!.start,
            type: zoomMeetingType,
            recurrenceConfiguration:
                bookingReader.recurrenceState == RecurrenceState.none
                    ? null
                    : recurrenceConfigurationModel,
          );
          print(zoomMeetingModel);
          final bookingModel = bookingFunction.createBookingModel();

          apiRepository
              .createMeeting(
            zoomMeetingModel,
            ref.watch(accessTokenNotifierProvider).value!.token,
          )
              .then((value) {
            print(value);
            print(value.data);
            // final zoomMeeting = ZoomMeetingModel.fromJson(value);
            // bookingModel.location = LocationData(
            //   web: zoomMeeting.joinUrl,
            //   chords: bookingReader.location?.chords,
            //   address: bookingReader.location?.address,
            // );
          });
          ref.read(bookingRepositoryProvider).createBooking(
                model: bookingModel,
                call: widget.errorCall,
                recurrence: recurrenceConfigurationModel,
              );
          Navigator.pop(context);
        } on FirebaseException catch (e) {
          throw e.message!;
        } catch (e) {
          Navigator.pop(context);
          widget.errorCall(
              e.toString().contains('Null check operator used on a null value')
                  ? 'Booking Failed! Fill in all the Data.'
                  : e.toString());
        }
      },
      child: const Text('Create Event'),
    );
  }
}
