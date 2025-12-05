import 'dart:math';

import 'package:api/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:util/util.dart';
import 'package:website/features/booking/provider/booking_provider.dart';
import 'package:website/features/booking/state/booking_state.dart';

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
  @override
  BookingState build() {
    return const BookingState();
  }

  clearState() {
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
    final startDate =
        currentRange?.start ?? DateTime.now(); // Keep existing date

    state = state.copyWith(
      timeRange: CustomDateTimeRange(
        start: DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
          startTime.hour,
          startTime.minute,
        ), // ✅ Only updating time
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
        end: DateTime(
          endDate.year,
          endDate.month,
          endDate.day,
          endTime.hour,
          endTime.minute,
        ), // ✅ Only updating time
      ),
    );
    if (state.timeRange != null) {
      if (state.timeRange!.start.isAfter(state.timeRange!.end)) {
        showFailureSnackBar(context, 'End Time Cannot Be Before Start Time');
      }
    }
  }

  BookingModel instantiateBookingModel(String? web) {
    final user = ref.watch(userProvider);
    final currentVenue = ref.read(bookingVenueStateProvider);

    if (user.value == null) {
      throw Exception('User not found. Please ensure you are logged in.');
    }

    return BookingModel(
      timeRange: state.timeRange!,
      createdAt: DateTime.now(),
      recurrenceState: state.recurrenceState,
      title: state.title!,
      password: state.password,
      host: user.value!.lastName ?? user.value!.name ?? '??',
      userId: user.value!.uid,
      id: FirebaseFirestore.instance.collection('dog').doc().id,
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
    final user = ref.read(userProvider);

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
    String? bookingId,
  ) {
    final bookingsAsync = ref.watch(getCurrentOrgBookingsStreamProvider);
    if (!bookingsAsync.hasValue) {
      throw 'No bookings found. Ensure internet connection is available.';
      // or throw an appropriate error
    }
    final List<BookingModel> bookings = bookingsAsync.value ?? <BookingModel>[];

    // Filter out current booking if updating
    final List<BookingModel> bookingsWithoutCurrent = bookings
        .where((element) => element.id != bookingId)
        .toList();

    // Check for overlap for non-recurring bookings
    if (state.recurrenceState == RecurrenceState.none) {
      bool overlaps = bookingsWithoutCurrent.any((booking) {
        return doTimeRangesOverlap(booking.timeRange, state.timeRange!);
      });
      if (overlaps) {
        throw 'Booking Failed, Date is Already Booked!. Check for Conflicting Dates That Are Already Booked.';
      }
    }

    CustomDateTimeRange shiftTimeRange(
      CustomDateTimeRange range, {
      int days = 0,
    }) {
      return CustomDateTimeRange(
        start: range.start.add(Duration(days: days)),
        end: range.end.add(Duration(days: days)),
      );
    }

    bool checkOverlap({bool isDaily = false, bool isWeekly = false}) {
      if (!isDaily && !isWeekly || bookingId != null) return false;

      return bookingsWithoutCurrent.any((booking) {
        for (var i = 0; i < state.recurrenceFrequency; i++) {
          final range = shiftTimeRange(
            state.timeRange!,
            days: isDaily ? i : i * 7,
          );
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
}

class MonthlyCalendarController {
  // --- Grid & Gradient Calculation Logic ---

  /// Utility to get the grid position (row and column) of a date relative to the current view
  Point<int> getGridPosition(DateTime date, DateTime displayDate) {
    final firstDayOfMonth = DateTime(displayDate.year, displayDate.month, 1);
    // Calculate the start of the calendar view (usually the Sunday/Monday before the 1st)
    final firstDayInView = firstDayOfMonth.subtract(
      Duration(days: firstDayOfMonth.weekday % 7),
    );

    final dayDifference = date.difference(firstDayInView).inDays;
    final row = dayDifference ~/ 7;
    final col = dayDifference % 7;
    return Point<int>(col, row);
  }

  /// Calculate gradient direction and intensity based on animation value
  Map<String, dynamic> getCellGradientInfo({
    required DateTime date,
    required DateTime selectedDate,
    required DateTime? previousSelectedDate,
    required DateTime currentDisplayDate,
    required double animationValue,
  }) {
    Map<String, dynamic> currentGradientInfo = _calculateGradientForDate(
      date,
      selectedDate,
      currentDisplayDate,
    );

    Map<String, dynamic> previousGradientInfo = previousSelectedDate != null
        ? _calculateGradientForDate(
            date,
            previousSelectedDate,
            currentDisplayDate,
          )
        : {
            'distance': 10.0,
            'start': Alignment.center,
            'end': Alignment.center,
            'intensity': 0.0,
          };

    final currentIntensity = currentGradientInfo['intensity'] as double;
    final previousIntensity = previousGradientInfo['intensity'] as double;

    // Interpolate between previous state and current state based on animation
    final interpolatedIntensity =
        previousIntensity +
        (currentIntensity - previousIntensity) * animationValue;

    return {
      'distance': currentGradientInfo['distance'],
      'start': currentGradientInfo['start'],
      'end': currentGradientInfo['end'],
      'intensity': interpolatedIntensity,
    };
  }

  /// Helper method to calculate gradient for a specific date using Manhattan distance
  Map<String, dynamic> _calculateGradientForDate(
    DateTime date,
    DateTime targetDate,
    DateTime displayDate,
  ) {
    // Determine grid positions
    final targetPos = getGridPosition(targetDate, displayDate);
    final currentPos = getGridPosition(date, displayDate);

    final rowDiff = targetPos.y - currentPos.y;
    final colDiff = targetPos.x - currentPos.x;

    // Manhattan distance
    final distance = (rowDiff.abs() + colDiff.abs()).toDouble();

    if (distance == 0) {
      return {
        'distance': 0.0,
        'start': Alignment.center,
        'end': Alignment.center,
        'intensity': 0.0,
      };
    }

    // Determine Gradient Direction based on relative position
    Alignment gradientStart;
    Alignment gradientEnd;

    if (rowDiff > 0 && colDiff == 0) {
      gradientStart = Alignment.topCenter;
      gradientEnd = Alignment.bottomCenter;
    } else if (rowDiff < 0 && colDiff == 0) {
      gradientStart = Alignment.bottomCenter;
      gradientEnd = Alignment.topCenter;
    } else if (rowDiff == 0 && colDiff > 0) {
      gradientStart = Alignment.centerLeft;
      gradientEnd = Alignment.centerRight;
    } else if (rowDiff == 0 && colDiff < 0) {
      gradientStart = Alignment.centerRight;
      gradientEnd = Alignment.centerLeft;
    } else if (rowDiff > 0 && colDiff > 0) {
      gradientStart = Alignment.topLeft;
      gradientEnd = Alignment.bottomRight;
    } else if (rowDiff > 0 && colDiff < 0) {
      gradientStart = Alignment.topRight;
      gradientEnd = Alignment.bottomLeft;
    } else if (rowDiff < 0 && colDiff > 0) {
      gradientStart = Alignment.bottomLeft;
      gradientEnd = Alignment.topRight;
    } else if (rowDiff < 0 && colDiff < 0) {
      gradientStart = Alignment.bottomRight;
      gradientEnd = Alignment.topLeft;
    } else {
      gradientStart = Alignment.center;
      gradientEnd = Alignment.center;
    }

    // Intensity calculation (fades out as distance increases)
    final intensity = 0.4 / (distance + 0);

    return {
      'distance': distance,
      'start': gradientStart,
      'end': gradientEnd,
      'intensity': intensity,
    };
  }

  // --- Booking Logic ---

  bool isFullyBooked(DateTime date, List<BookingModel> bookings) {
    // Get all bookings for this specific date
    final dayBookings = bookings
        .where((booking) => isOverlapping(date, booking.timeRange))
        .toList();

    if (dayBookings.isEmpty) return false;

    // Create a list of all time ranges for this date
    List<CustomDateTimeRange> timeRanges = dayBookings.map((booking) {
      // Get start time for this date
      DateTime startTime;
      if (booking.timeRange.start.day == date.day) {
        startTime = booking.timeRange.start;
      } else {
        startTime = DateTime(date.year, date.month, date.day, 0, 0);
      }

      // Get end time for this date
      DateTime endTime;
      if (booking.timeRange.end.day == date.day) {
        endTime = booking.timeRange.end;
      } else {
        endTime = DateTime(date.year, date.month, date.day, 23, 59, 59);
      }

      return CustomDateTimeRange(start: startTime, end: endTime);
    }).toList();

    // Sort time ranges by start time
    timeRanges.sort((a, b) => a.start.compareTo(b.start));

    // Merge overlapping time ranges
    List<CustomDateTimeRange> mergedRanges = [];
    CustomDateTimeRange? currentRange;

    for (var range in timeRanges) {
      if (currentRange == null) {
        currentRange = range;
      } else if (range.start.isBefore(currentRange.end) ||
          range.start.isAtSameMomentAs(currentRange.end)) {
        // Ranges overlap, merge them
        currentRange = CustomDateTimeRange(
          start: currentRange.start,
          end: range.end.isAfter(currentRange.end)
              ? range.end
              : currentRange.end,
        );
      } else {
        // No overlap, add current range and start new one
        mergedRanges.add(currentRange);
        currentRange = range;
      }
    }
    if (currentRange != null) {
      mergedRanges.add(currentRange);
    }

    // Calculate total non-overlapping minutes
    int totalMinutes = mergedRanges.fold(0, (sum, range) {
      return sum + range.duration.inMinutes;
    });

    // A day is considered fully booked if total booked time is >= 24 hours (1439 minutes to be safe)
    return totalMinutes >= 1439;
  }
}

@riverpod
class SelectedBookingIDNotifier extends _$SelectedBookingIDNotifier {
  @override
  String build() {
    return ''; // Initial state
  }

  void updateID(String id) {
    state = id; // Update the state with the selected date
  }
}
