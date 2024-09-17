import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_shaddai/api/models/recurrence_configuration_model/recurrence_configuration_model.dart';
import 'package:el_shaddai/features/auth/controller/auth_controller.dart';
import 'package:el_shaddai/features/booking/state/booking_state.dart';
import 'package:el_shaddai/models/booking_model/booking_model.dart';
import 'package:el_shaddai/models/location_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:time_range_picker/time_range_picker.dart';
part 'booking_controller.g.dart';

enum BookingVenueComponent { location, zoom, hybrid }

@riverpod
class BookingVenueState extends _$BookingVenueState {
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
              address: state.location?.address ?? 'default address', web: web),
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
      timeRange: DateTimeRange(
        start: DateTime(
          timeRange.start.year,
          timeRange.start.month,
          timeRange.start.day,
          start?.hour ?? 11,
        ),
        end: DateTime(
          timeRange.start.year,
          timeRange.start.month,
          timeRange.start.day,
          end?.hour ?? 12,
        ),
      ),
    );
  }

  void setTimeRange(TimeRange timeOfDay) {
    final start = state.timeRange?.start;
    final end = state.timeRange?.end;
    state = state.copyWith(
      timeRange: DateTimeRange(
        start: DateTime(
          start?.year ?? 2222,
          start?.month ?? 1,
          start?.day ?? 12,
          timeOfDay.startTime.hour,
        ),
        end: DateTime(
          end?.year ?? 2222,
          end?.month ?? 2,
          end?.day ?? 2,
          timeOfDay.endTime.hour,
        ),
      ),
    );
  }

  BookingModel createBookingModel() {
    final user = ref.read(userProvider);
    final currentVenue = ref.read(bookingVenueStateProvider);
    return BookingModel(
      recurrenceState: state.recurrenceState,
      title: state.title!,
      hostId: user!.uid,
      timeRange: state.timeRange!,
      userId: user.uid,
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

  RecurrenceConfigurationModel? getRecurrenceConfigurationModel() {
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

  bool isBookingDataValid(
      GlobalKey<FormState> formKey, void Function(String) errorCall) {
    final currentVenue = ref.read(bookingVenueStateProvider);
    final user = ref.read(userProvider);
    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) return false;
    final title = state.title;
    final timeRange = state.timeRange;
    final location = state.location;
    final description = state.description;
    if (user == null) {
      errorCall('No User,Make sure internet connection is available');
      return false;
    }
    // print(
    //     '${bookingReader.title}${bookingReader.timeRange}${bookingReader.location}${bookingReader.description} ${currentVenue} ${user}');
    return (title == null ||
        timeRange == null ||
        (currentVenue != BookingVenueComponent.zoom && location == null) ||
        description == null ||
        (location != null &&
            location.address!.isEmpty &&
            currentVenue != BookingVenueComponent.zoom));
  }

  int getZoomMeetingType() {
    return state.recurrenceState == RecurrenceState.none ? 2 : 8;
  }
}
