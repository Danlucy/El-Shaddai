import 'package:mobile/features/booking/state/booking_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_clipboard.g.dart';

@Riverpod(
  keepAlive: true,
) // KeepAlive is crucial so data persists across screens
class BookingClipboard extends _$BookingClipboard {
  @override
  BookingState? build() {
    return null; // Initially empty
  }

  // Call this when user taps "Copy" on a booking card
  void copy(BookingState stateToCopy) {
    // We strip specific IDs so it treats it as a new booking
    state = stateToCopy.copyWith(
      bookingId: null,
      hostId: null, // Optional: clear host if needed
    );
  }

  // Helper to check if we have data to paste
  bool get hasContent => state != null;

  void clear() {
    state = null;
  }
}
