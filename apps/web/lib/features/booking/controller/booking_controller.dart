import 'package:models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:util/util.dart';

part 'booking_controller.g.dart';

class MonthlyCalendarController {
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
                : currentRange.end);
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

    // A day is considered fully booked if total booked time is >= 24 hours (1440 minutes)
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
