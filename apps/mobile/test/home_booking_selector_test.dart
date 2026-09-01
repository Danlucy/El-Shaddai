import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/home/home_booking_selector.dart';
import 'package:models/models.dart';
import 'package:util/util.dart';

BookingModel booking({
  required String id,
  required DateTime start,
  required DateTime end,
}) {
  return BookingModel(
    id: id,
    title: id,
    recurrenceState: RecurrenceState.none,
    host: 'Host',
    createdAt: DateTime(2026),
    timeRange: CustomDateTimeRange(start: start, end: end),
    userId: 'user',
    location: LocationData(address: 'Address'),
    description: 'Description',
  );
}

void main() {
  final now = DateTime(2026, 8, 18, 12);

  test('selects a live booking before an upcoming booking', () {
    final live = booking(
      id: 'live',
      start: now.subtract(const Duration(minutes: 30)),
      end: now.add(const Duration(minutes: 30)),
    );
    final upcoming = booking(
      id: 'upcoming',
      start: now.add(const Duration(hours: 1)),
      end: now.add(const Duration(hours: 2)),
    );

    expect(selectCurrentOrUpcomingBooking([upcoming, live], now), same(live));
    expect(isBookingLive(live, now), isTrue);
  });

  test('selects the nearest upcoming booking and ignores past bookings', () {
    final past = booking(
      id: 'past',
      start: now.subtract(const Duration(hours: 2)),
      end: now.subtract(const Duration(hours: 1)),
    );
    final next = booking(
      id: 'next',
      start: now.add(const Duration(minutes: 20)),
      end: now.add(const Duration(hours: 1)),
    );
    final later = booking(
      id: 'later',
      start: now.add(const Duration(days: 1)),
      end: now.add(const Duration(days: 1, hours: 1)),
    );

    expect(
      selectCurrentOrUpcomingBooking([later, past, next], now),
      same(next),
    );
    expect(isBookingLive(next, now), isFalse);
  });

  test('returns null when there are no live or future bookings', () {
    final endedNow = booking(
      id: 'ended',
      start: now.subtract(const Duration(hours: 1)),
      end: now,
    );

    expect(selectCurrentOrUpcomingBooking([endedNow], now), isNull);
  });
}
