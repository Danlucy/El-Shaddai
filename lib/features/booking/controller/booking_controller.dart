import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:el_shaddai/api/models/recurrence_configuration_model/recurrence_configuration_model.dart';
import 'package:el_shaddai/api/models/zoom_meeting_model/zoom_meeting_model.dart';
import 'package:el_shaddai/core/customs/custom_date_time_range.dart';
import 'package:el_shaddai/core/utility/date_time_range.dart';
import 'package:el_shaddai/features/auth/controller/auth_controller.dart';
import 'package:el_shaddai/features/booking/repository/booking_repository.dart';
import 'package:el_shaddai/features/booking/state/booking_state.dart';
import 'package:el_shaddai/models/booking_model/booking_model.dart';
import 'package:el_shaddai/models/location_data.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:time_range_picker/time_range_picker.dart';
part 'booking_controller.g.dart';

enum BookingVenueComponent { location, zoom, hybrid }

@riverpod
class BookingVenueState extends _$BookingVenueState {
  @override
  BookingVenueComponent build() {
    return BookingVenueComponent.location;
  }

  void setVenue(BookingVenueComponent target) {
    state = target;
  }
}

@riverpod
class BookingController extends _$BookingController {
  @override
  BookingState build() {
    return const BookingState();
  }

  clearState() {
    state = const BookingState();
  }

  void setTitle(String title) => state = state.copyWith(title: title);

  void setDescription(String description) =>
      state = state.copyWith(description: description);
  void setLocation(LocationData location) =>
      state = state.copyWith(location: location);
  void setRecurrenceFrequency(int frequency) =>
      state = state.copyWith(recurrenceFrequency: frequency);
  void setAddress(String address) {
    state = state.copyWith(
      location: state.location?.copyWith(
            address: address,
          ) ??
          LocationData(address: address),
    );
  }

  void setWeb(String? web) {
    state = state.copyWith(
      location: state.location?.copyWith(
            web: web,
          ) ??
          LocationData(
              chords: state.location?.chords,
              address: state.location?.address,
              web: web),
    );
  }

  void setChords(LatLng? chords) {
    if (chords == null) {
      state = BookingState(
          description: state.description,
          title: state.title,
          location: LocationData(
              address: state.location?.address ?? 'default address',
              web: state.location?.web,
              chords: null),
          bookingId: state.bookingId,
          hostId: state.hostId,
          recurrenceFrequency: state.recurrenceFrequency,
          recurrenceState: state.recurrenceState,
          timeRange: state.timeRange);
    } else {
      state = state.copyWith(
        location: state.location?.copyWith(
              chords: chords,
            ) ??
            LocationData(
                address: state.location?.address ?? 'default address',
                chords: chords),
      );
    }
  }

  void setEventId(String bookingId) =>
      state = state.copyWith(bookingId: bookingId);
  void setHostId(String hostId) => state = state.copyWith(hostId: hostId);
  void setRecurrenceState(RecurrenceState recurrenceState) =>
      state = state.copyWith(recurrenceState: recurrenceState);
  void setDateRange(DateTimeRange timeRange) {
    final start = state.timeRange?.start;
    final end = state.timeRange?.end;
    state = state.copyWith(
      timeRange: CustomDateTimeRange(
        start: DateTime(
          timeRange.start.year,
          timeRange.start.month,
          timeRange.start.day,
          start?.hour ?? 11,
          start?.minute ?? 0,
        ),
        end: DateTime(
          timeRange.end.year,
          timeRange.end.month,
          timeRange.end.day,
          end?.hour ?? 12,
          end?.minute ?? 0,
        ),
      ),
    );
  }

  void setTimeRange(TimeRange timeOfDay) {
    final start = state.timeRange?.start;
    final end = state.timeRange?.end;
    state = state.copyWith(
      timeRange: CustomDateTimeRange(
        start: DateTime(start?.year ?? 0, start?.month ?? 0, start?.day ?? 0,
            timeOfDay.startTime.hour, timeOfDay.startTime.minute),
        end: DateTime(end?.year ?? 0, end?.month ?? 0, end?.day ?? 0,
            timeOfDay.endTime.hour, timeOfDay.endTime.minute),
      ),
    );
  }

  BookingModel instantiateBookingModel(String? web) {
    final user = ref.read(userProvider);
    final currentVenue = ref.read(bookingVenueStateProvider);
    return BookingModel(
      timeRange: state.timeRange!,
      createdAt: DateTime.now(),
      recurrenceState: state.recurrenceState,
      title: state.title!,
      host: user!.name,
      userId: user.uid,
      id: FirebaseFirestore.instance.collection('dog').doc().id,
      location: LocationData(
        web: currentVenue == BookingVenueComponent.location ? null : web,
        chords: currentVenue == BookingVenueComponent.zoom
            ? null
            : state.location?.chords,
        address: currentVenue == BookingVenueComponent.zoom
            ? null
            : state.location?.address,
      ),
      description: state.description!,
    );
  }

  RecurrenceConfigurationModel? instantiateRecurrenceConfigurationModel() {
    if (state.recurrenceState == RecurrenceState.none) return null;

    return RecurrenceConfigurationModel(
      weeklyDays: state.recurrenceState == RecurrenceState.weekly
          ? Weekday.fromDateTime(state.timeRange!.start).value
          : null,
      recurrenceFrequency: state.recurrenceFrequency,
      type: state.recurrenceState == RecurrenceState.daily ? 1 : 2,
      recurrenceInterval: 1,
    );
  }

  ZoomMeetingModel instantiateZoomMeetingModel() {
    return ZoomMeetingModel(
      topic: state.title,
      duration: state.timeRange!.duration.inMinutes,
      description: state.description,
      startTime: state.timeRange!.start,
      type: state.recurrenceState == RecurrenceState.none ? 2 : 8,
      recurrenceConfiguration: state.recurrenceState == RecurrenceState.none
          ? null
          : instantiateRecurrenceConfigurationModel(),
    );
  }

  bool isBookingDataInvalid(
    GlobalKey<FormState> formKey,
  ) {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) throw 'Booking Failed! Fill in all the data.';

    final currentVenue = ref.read(bookingVenueStateProvider);

    final location = state.location;

    final requiredFields = [state.title, state.timeRange, state.description];
    if (requiredFields.any((field) => field == null)) {
      throw 'All fields are required.';
    }

    final user = ref.read(userProvider);
    if (user == null) {
      throw 'No user found. Ensure internet connection is available.';
    }
    if (currentVenue != BookingVenueComponent.zoom &&
        (location == null || location.address?.isEmpty == true)) {
      throw 'Location details are required.';
    }
    // print(
    //     'Title:${state.title} TimeRange: ${state.timeRange} Location: ${state.location} Desc: ${state.description} $currentVenue USER IS $user');

    // print((currentVenue != BookingVenueComponent.zoom && location == null));
    // print((location != null &&
    //     location.address!.isEmpty &&
    //     currentVenue != BookingVenueComponent.zoom));
    // print(timeRange == null);
    // print((title == null ||
    //     timeRange == null ||
    //     (currentVenue != BookingVenueComponent.zoom && location == null) ||
    //     description == null ||
    //     (location != null &&
    //         location.address!.isEmpty &&
    //         currentVenue != BookingVenueComponent.zoom)));
    return false;
  }

  // bool isBookingDataInvalid(
  //   GlobalKey<FormState> formKey,
  // ) {
  //   if (_isBookingDataInvalid(formKey) ||
  //       !(formKey.currentState?.validate() ?? false)) {
  //     throw 'Booking Failed! Fill in all the Data.';
  //   }
  //   return false;
  // }

  bool isTimeRangeInvalid(BuildContext context) {
    final bookings =
        ref.watch(bookingsProvider).valueOrNull ?? <BookingModel>[];

    CustomDateTimeRange shiftTimeRange(CustomDateTimeRange range,
        {int days = 0}) {
      return CustomDateTimeRange(
        start: range.start.add(Duration(days: days)),
        end: range.end.add(Duration(days: days)),
      );
    }

    bool checkDailyOverlap() {
      if (state.recurrenceState == RecurrenceState.none) {
        return bookings.any((booking) {
          return doTimeRangesOverlap(booking.timeRange, state.timeRange!);
        });
      }
      if (state.recurrenceState != RecurrenceState.daily) return false;
      return bookings.any((booking) {
        for (var i = 0; i < state.recurrenceFrequency; i++) {
          final range = shiftTimeRange(state.timeRange!, days: i);
          if (doTimeRangesOverlap(booking.timeRange, range)) return true;
        }
        return false;
      });
    }

    bool checkWeeklyOverlap() {
      if (state.recurrenceState != RecurrenceState.weekly) return false;
      return bookings.any((booking) {
        for (var i = 0; i < state.recurrenceFrequency; i++) {
          final range = shiftTimeRange(state.timeRange!, days: i * 7);
          if (doTimeRangesOverlap(booking.timeRange, range)) return true;
        }
        return false;
      });
    }

    if (checkDailyOverlap()) {
      throw 'Daily Booking Failed! Date is Already Booked!.';
    } else if (checkWeeklyOverlap()) {
      throw 'Weekly Booking Failed! Date is Already Booked!.';
    }

    // final booking = bookings.firstWhereOrNull(
    //   (element) {
    //     if (state.recurrenceState == RecurrenceState.daily) {
    //       for (var i = 0; i < state.recurrenceFrequency; i++) {
    //         if (doTimeRangesOverlap(
    //           element.timeRange,
    //           CustomDateTimeRange(
    //             start: state.timeRange!.start.add(Duration(
    //               days: i,
    //             )), // Add 1 day to the start
    //             end: state.timeRange!.end.add(Duration(
    //               days: i,
    //             )), // Add 1 day to the end
    //           ),
    //         )) {
    //           throw 'Daily Booking Failed! Date is Already Booked!.';
    //         }
    //       }
    //     } else if (state.recurrenceState == RecurrenceState.weekly) {
    //       for (var i = 0; i < state.recurrenceFrequency; i++) {
    //         if (doTimeRangesOverlap(
    //           element.timeRange,
    //           CustomDateTimeRange(
    //             start: state.timeRange!.start.add(
    //               Duration(days: i * 7),
    //             ), // Add 1 day to the start
    //             end: state.timeRange!.end.add(
    //               Duration(days: i * 7),
    //             ), // Add 1 day to the end
    //           ),
    //         )) {
    //           throw 'Weekly Booking Failed! Date is Already Booked!.';
    //         }
    //       }
    //     } else {
    //       return doTimeRangesOverlap(element.timeRange, state.timeRange!);
    //     }
    //     return doTimeRangesOverlap(element.timeRange, state.timeRange!);
    //   },
    // );

    if (state.recurrenceState == RecurrenceState.daily &&
        state.timeRange!.duration > const Duration(days: 1)) {
      throw 'Daily bookings cant be more than 1 day!.';
    }
    if (state.recurrenceState == RecurrenceState.weekly &&
        state.timeRange!.duration > const Duration(days: 7)) {
      throw 'Weekly bookings cant be more than 7 day!.';
    }
    if (state.timeRange!.end.isBeforeOrEqualTo(state.timeRange!.start)) {
      throw 'Start Time Cannot Be After End Time.';
    }
    if (state.timeRange!.start.isBefore(DateTime.now())) {
      throw 'Booking Failed! Time is in the past.';
    }
    return false;
  }
}
