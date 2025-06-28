import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../api/models/recurrence_configuration_model/recurrence_configuration_model.dart';
import '../../../api/models/zoom_meeting_model/zoom_meeting_model.dart';
import '../../../core/customs/custom_date_time_range.dart';
import '../../../core/utility/date_time_range.dart';
import '../../../core/widgets/snack_bar.dart';
import '../../../models/booking_model/booking_model.dart';
import '../../../models/location_data.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/booking_repository.dart';
import '../state/booking_state.dart';
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

  void switchVenue(BookingModel booking) {
    if (booking.location.web != null && booking.location.address != null) {
      state = BookingVenueComponent.hybrid; // ✅ Both web and address exist
    } else if (booking.location.web == null &&
        booking.location.address != null) {
      state = BookingVenueComponent.location; // ✅ Only address exists
    } else if (booking.location.web != null &&
        booking.location.address == null) {
      state = BookingVenueComponent.zoom; // ✅ Only web exists
    }
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

  void setState(
    BookingModel newState,
  ) {
    state = BookingState(
      bookingId: newState.id,
      description: newState.description,
      hostId: newState.userId,
      location: newState.location,
      recurrenceFrequency: newState.recurrenceModel?.recurrenceFrequency ?? 2,
      recurrenceState: newState.recurrenceState,
      timeRange: newState.timeRange,
      title: newState.title,
    );
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

  // void setTimeRange(TimeRange timeOfDay) {
  //   final start = state.timeRange?.start;
  //   final end = state.timeRange?.end;
  //   state = state.copyWith(
  //     timeRange: CustomDateTimeRange(
  //       start: DateTime(start?.year ?? 0, start?.month ?? 0, start?.day ?? 0,
  //           timeOfDay.startTime.hour, timeOfDay.startTime.minute),
  //       end: DateTime(end?.year ?? 0, end?.month ?? 0, end?.day ?? 0,
  //           timeOfDay.endTime.hour, timeOfDay.endTime.minute),
  //     ),
  //   );
  // }
  void setStartTime(DateTime startTime, BuildContext context) {
    final currentRange = state.timeRange;
    final startDate =
        currentRange?.start ?? DateTime.now(); // Keep existing date

    state = state.copyWith(
      timeRange: CustomDateTimeRange(
        start: DateTime(startDate.year, startDate.month, startDate.day,
            startTime.hour, startTime.minute), // ✅ Only updating time
        end: currentRange?.end ?? startDate, // Keep end time unchanged
      ),
    );
    if (state.timeRange != null) {
      if (state.timeRange!.end.isBefore(state.timeRange!.start)) {
        showFailureSnackBar(context, 'Start Time Cannot Be After End Time');
      }
    }
  }

  void setEndTime(DateTime endTime, BuildContext context) {
    final currentRange = state.timeRange;
    final endDate = currentRange?.end ?? DateTime.now(); // Keep existing date

    state = state.copyWith(
      timeRange: CustomDateTimeRange(
        start: currentRange?.start ?? endDate, // Keep start time unchanged
        end: DateTime(endDate.year, endDate.month, endDate.day, endTime.hour,
            endTime.minute), // ✅ Only updating time
      ),
    );
    if (state.timeRange != null) {
      if (state.timeRange!.start.isAfter(state.timeRange!.end)) {
        showFailureSnackBar(context, 'End Time Cannot Be Before Start Time');
      }
    }
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

  bool isBookingDataInvalid(GlobalKey<FormState> formKey) {
    if (!(formKey.currentState?.validate() ?? false)) {
      throw 'Booking Failed! Fill in all the data.';
    }

    final currentVenue = ref.read(bookingVenueStateProvider);
    final location = state.location;
    final user = ref.read(userProvider);

    if (user == null) {
      throw 'No user found. Ensure internet connection is available.';
    }

    if ([state.title, state.timeRange, state.description]
        .any((field) => field == null)) {
      throw 'All fields are required.';
    }

    if (currentVenue != BookingVenueComponent.zoom &&
        (location == null || location.address?.isEmpty == true)) {
      throw 'Location details are required.';
    }

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

  bool isTimeRangeInvalid(
      BuildContext context, bool isUpdating, String? bookingId) {
    final List<BookingModel> bookings =
        ref.watch(bookingStreamProvider()).valueOrNull ?? <BookingModel>[];

    // Filter out current booking if updating
    final List<BookingModel> bookingsWithoutCurrent =
        bookings.where((element) => element.id != bookingId).toList();

    // Check for overlap for non-recurring bookings
    if (state.recurrenceState == RecurrenceState.none) {
      bool overlaps = bookingsWithoutCurrent.any((booking) {
        return doTimeRangesOverlap(booking.timeRange, state.timeRange!);
      });
      if (overlaps) {
        throw 'Booking Failed, Date is Already Booked!. Check for Conflicting Dates That Are Already Booked.';
      }
    }

    CustomDateTimeRange shiftTimeRange(CustomDateTimeRange range,
        {int days = 0}) {
      return CustomDateTimeRange(
        start: range.start.add(Duration(days: days)),
        end: range.end.add(Duration(days: days)),
      );
    }

    bool checkOverlap({bool isDaily = false, bool isWeekly = false}) {
      if (!isDaily && !isWeekly || bookingId != null) return false;

      return bookingsWithoutCurrent.any((booking) {
        for (var i = 0; i < state.recurrenceFrequency; i++) {
          final range =
              shiftTimeRange(state.timeRange!, days: isDaily ? i : i * 7);
          if (doTimeRangesOverlap(booking.timeRange, range)) return true;
        }
        return false;
      });
    }

    if (state.recurrenceState == RecurrenceState.daily &&
        checkOverlap(isDaily: true)) {
      throw 'Daily Booking Failed, Date is Already Booked!. Check for Conflicting Dates That Are Already Booked.';
    }

    if (state.recurrenceState == RecurrenceState.weekly &&
        checkOverlap(isWeekly: true)) {
      throw 'Weekly Booking Failed, Date is Already Booked!. Check for Conflicting Dates That Are Already Booked';
    }

    // Validate duration constraints
    final maxDuration = state.recurrenceState == RecurrenceState.daily
        ? const Duration(days: 1)
        : state.recurrenceState == RecurrenceState.weekly
            ? const Duration(days: 7)
            : const Duration(hours: 24); // max 24 hours for none

    if (state.timeRange!.duration > maxDuration) {
      throw '${state.recurrenceState == RecurrenceState.none ? "Single" : state.recurrenceState} bookings can\'t be more than ${maxDuration.inDays != 0 ? maxDuration.inDays : maxDuration.inHours}  ${maxDuration.inDays != 0 ? "day(s)" : "hour(s)"} !.';
    }

    // Check time range validity
    if (state.timeRange!.end.isBeforeOrEqualTo(state.timeRange!.start)) {
      throw 'Start Time Cannot Be After End Time.';
    }

    if (state.timeRange!.start.isBefore(DateTime.now())) {
      throw 'Booking Failed! Time is in the past. Start Time cannot be after End Time!';
    }

    return false;
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
}
