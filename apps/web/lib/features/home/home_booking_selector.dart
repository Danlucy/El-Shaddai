import 'package:models/models.dart';

BookingModel? selectCurrentOrUpcomingBooking(
  Iterable<BookingModel> bookings,
  DateTime now,
) {
  final visibleBookings =
      bookings.where((booking) => booking.timeRange.end.isAfter(now)).toList()
        ..sort(
          (first, second) =>
              first.timeRange.start.compareTo(second.timeRange.start),
        );

  for (final booking in visibleBookings) {
    if (!booking.timeRange.start.isAfter(now)) return booking;
  }

  return visibleBookings.isEmpty ? null : visibleBookings.first;
}

bool isBookingLive(BookingModel booking, DateTime now) {
  return !booking.timeRange.start.isAfter(now) &&
      booking.timeRange.end.isAfter(now);
}
