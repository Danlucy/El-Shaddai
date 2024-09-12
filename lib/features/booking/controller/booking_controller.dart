import 'package:el_shaddai/features/booking/state/booking_state.dart';
import 'package:el_shaddai/models/location_data.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:http/http.dart' as http;
part 'booking_controller.g.dart';

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

  // void getAccessToken() {
  //   const url = 'https://zoom.us/oauth/';
  //   final uri = Uri.parse(url);
  //   final header = {
  //     "Authorization":
  //         "Basic 8RVTda4nTpaR6h5XVpzL0A:NyPF1sBkWfJKX2kW59waqqlmel4c6Xeu"
  //   };
  //   final respsme = http.post(uri, headers: header);
  // }
  //
  // void createMeeting() {
  //   const url = 'https://api.zoom.us/v2/users/me/meetings';
  //   final uri = Uri.parse(url);
  //   // http.post(uri,)
  // }
}
