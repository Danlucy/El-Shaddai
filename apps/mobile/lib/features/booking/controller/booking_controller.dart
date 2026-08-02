import 'package:api/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile/features/booking/controller/booking_clipboard.dart';
import 'package:mobile/features/booking/provider/booking_provider.dart';
import 'package:mobile/features/booking/state/booking_state.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:util/util.dart';

import '../../auth/controller/auth_controller.dart';

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
  Map<String, dynamic>? occurrenceIds;

  @override
  BookingState build() {
    return const BookingState();
  }

  void clearState() {
    state = const BookingState();
  }

  void switchVenueBasedOnCurrentState() {
    if (state.location?.web != null && state.location?.address != null) {
      ref
          .read(bookingVenueStateProvider.notifier)
          .setVenue(
            BookingVenueComponent.hybrid,
          ); // ✅ Both web and address exist
    } else if (state.location?.web == null && state.location?.address != null) {
      ref
          .read(bookingVenueStateProvider.notifier)
          .setVenue(BookingVenueComponent.location); // ✅ Only address exists
    } else if (state.location?.web != null && state.location?.address == null) {
      ref
          .read(bookingVenueStateProvider.notifier)
          .setVenue(BookingVenueComponent.zoom); // ✅ Only web exists}
    }
  }

  void pasteFromClipboard(BuildContext context) {
    // 1. Read the clipboard state
    final clipboardState = ref.read(bookingClipboardProvider);
    if (clipboardState == null) {
      showFailureSnackBar(context, 'No Booking is Currently Copied');
      return;
    }

    state = clipboardState;

    // 3. Update the Venue Toggle logic (Zoom/Location/Hybrid)
    switchVenueBasedOnCurrentState();
  }

  void setState(BookingModel newState) {
    state = BookingState(
      password: newState.password,
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

  void copyState(BookingModel booking) {
    setState(booking);
    state = state.copyWith(bookingId: null);
  }

  void setTitle(String title) => state = state.copyWith(title: title);

  void setDescription(String description) =>
      state = state.copyWith(description: description);

  void setLocation(LocationData location) =>
      state = state.copyWith(location: location);
  void setPassword(String? password) =>
      state = state.copyWith(password: password);

  void setRecurrenceFrequency(int frequency) =>
      state = state.copyWith(recurrenceFrequency: frequency);

  void setAddress(String address) {
    state = state.copyWith(
      location:
          state.location?.copyWith(address: address) ??
          LocationData(address: address),
    );
  }

  void setWeb(String? web) {
    state = state.copyWith(
      location:
          state.location?.copyWith(web: web) ??
          LocationData(
            chords: state.location?.chords,
            address: state.location?.address,
            web: web,
          ),
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
          chords: null,
        ),
        bookingId: state.bookingId,
        hostId: state.hostId,
        recurrenceFrequency: state.recurrenceFrequency,
        recurrenceState: state.recurrenceState,
        timeRange: state.timeRange,
      );
    } else {
      state = state.copyWith(
        location:
            state.location?.copyWith(chords: chords) ??
            LocationData(
              address: state.location?.address ?? 'default address',
              chords: chords,
            ),
      );
    }
  }

  void setOccurenceId(Map<String, dynamic>? occurenceId) => occurrenceIds;

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
          start?.hour ?? DateTime.now().hour,
          start?.minute ?? (DateTime.now().minute / 5).ceil() * 5,
        ),
        end: DateTime(
          timeRange.end.year,
          timeRange.end.month,
          timeRange.end.day,
          end?.hour ?? (DateTime.now().add(const Duration(hours: 1)).hour),
          end?.minute ?? (DateTime.now().minute / 5).ceil() * 5,
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
    final currentDate = currentRange?.start ?? DateTime.now();

    // 1. Construct the new start DateTime with the updated time
    final newStart = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      startTime.hour,
      startTime.minute,
    );

    // 2. Get the current end time, defaulting to 1 hour after start if it doesn't exist yet
    DateTime newEnd =
        currentRange?.end ?? newStart.add(const Duration(hours: 1));

    if (newEnd.isBefore(newStart) || newEnd.isAtSameMomentAs(newStart)) {
      newEnd = newStart.add(const Duration(hours: 1));
    }

    // 4. Update the state with the validated range
    state = state.copyWith(
      timeRange: CustomDateTimeRange(start: newStart, end: newEnd),
    );
  }

  void setEndTime(DateTime endTime, BuildContext context) {
    final currentRange = state.timeRange;
    final currentDate =
        currentRange?.end ?? DateTime.now(); // Keep existing date
    final DateTime newEnd = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      endTime.hour,
      endTime.minute,
    );
    DateTime newStart =
        currentRange?.start ?? newEnd.add(const Duration(hours: 1));
    if (newStart.isAfter(newEnd) || newStart.isAtSameMomentAs(newEnd)) {
      newStart = newEnd.subtract(const Duration(hours: 1));
    }

    state = state.copyWith(
      timeRange: CustomDateTimeRange(
        start: newStart, // Keep start time unchanged
        end: newEnd,
      ),
    );
  }

  BookingDTO instantiateBookingDTO({
    required String organizationId,
    required bool isUpdating,
    required List<dynamic>? zoomOccurrences,
  }) {
    final user = ref.read(userProvider).value;
    final currentVenue = ref.read(bookingVenueStateProvider);
    final timeRange = state.timeRange!;

    return BookingDTO(
      requestId: FirebaseFirestore.instance
          .collection('bookingRequests')
          .doc()
          .id,
      organizationId: organizationId,
      isUpdating: isUpdating,
      bookingId: state.bookingId,
      timezoneOffsetMinutes: timeRange.start.timeZoneOffset.inMinutes,
      timeRange: state.timeRange!,
      recurrenceState: state.recurrenceState,
      title: state.title!,
      password: state.password,
      host: user!.lastName ?? user.name,
      location: LocationData(
        web: currentVenue == BookingVenueComponent.location
            ? null
            : state.location?.web,
        chords: currentVenue == BookingVenueComponent.zoom
            ? null
            : state.location?.chords,
        address: currentVenue == BookingVenueComponent.zoom
            ? null
            : state.location?.address,
      ),
      description: state.description!,
      recurrence: instantiateRecurrenceConfigurationModel(),
      zoomOccurrences: zoomOccurrences
          ?.map(BookingSubmissionZoomOccurrence.fromZoomResponse)
          .toList(growable: false),
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
      defaultPassword: false,
      password: state.password,
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
    final user = ref.read(userProvider).value;

    if (user == null) {
      throw 'No user found. Ensure internet connection is available.';
    }

    if ([
      state.title,
      state.timeRange,
      state.description,
    ].any((field) => field == null)) {
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
    BuildContext context,
    bool isUpdating,
    String? bookingId, {
    bool checkCachedOverlap = true,
  }) {
    if (isUpdating && bookingId == null) {
      throw 'Booking update failed. The booking ID is missing. Close this form and reopen the booking before trying again.';
    }

    if (checkCachedOverlap) {
      final bookingsAsync = ref.watch(getCurrentOrgBookingsStreamProvider);
      if (!bookingsAsync.hasValue) {
        throw 'No bookings found. Ensure internet connection is available.';
      }
      final List<BookingModel> bookings =
          bookingsAsync.value ?? <BookingModel>[];

      // Filter out current booking if updating
      final List<BookingModel> bookingsWithoutCurrent = bookings
          .where((element) => element.id != bookingId)
          .toList();

      CustomDateTimeRange shiftTimeRange(
        CustomDateTimeRange range, {
        int days = 0,
      }) {
        return CustomDateTimeRange(
          start: range.start.add(Duration(days: days)),
          end: range.end.add(Duration(days: days)),
        );
      }

      final candidateRanges = <CustomDateTimeRange>[];
      if (state.recurrenceState == RecurrenceState.none || isUpdating) {
        candidateRanges.add(state.timeRange!);
      } else {
        final isDaily = state.recurrenceState == RecurrenceState.daily;
        for (var i = 0; i < state.recurrenceFrequency; i++) {
          candidateRanges.add(
            shiftTimeRange(state.timeRange!, days: isDaily ? i : i * 7),
          );
        }
      }

      final overlappingDates = findOverlappingDates(
        candidateRanges: candidateRanges,
        existingRanges: bookingsWithoutCurrent.map(
          (booking) => booking.timeRange,
        ),
      );
      if (overlappingDates.isNotEmpty) {
        final bookingType = switch (state.recurrenceState) {
          RecurrenceState.none => 'Booking',
          RecurrenceState.daily => 'Daily booking',
          RecurrenceState.weekly => 'Weekly booking',
        };
        final dateLabel = overlappingDates.length == 1 ? 'date' : 'dates';
        throw '$bookingType failed. Conflicting $dateLabel: ${formatOverlappingDates(overlappingDates)}.';
      }
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

  FutureEither<void> deleteBooking(
    BookingModel bookingModel, {
    required bool deleteEntireSeries,
  }) {
    return ref
        .read(currentOrgRepositoryProvider)
        .deleteBooking(
          bookingModel: bookingModel,
          deleteEntireSeries: deleteEntireSeries,
        );
  }

  /// 🔹 REFACTORED: Recurring Check & Execution
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
