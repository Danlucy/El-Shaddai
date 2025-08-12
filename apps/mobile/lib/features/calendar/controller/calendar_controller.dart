import 'package:models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:util/util.dart';

part 'calendar_controller.g.dart';

@riverpod
class CalendarDateNotifier extends _$CalendarDateNotifier {
  @override
  DateTime build() {
    return DateTime.now(); // Initial state
  }

  void updateSelectedDate(DateTime date) {
    state = date; // Update the state with the selected date
  }
}

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

class BookingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  BookingDataSource(List<BookingModel> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).timeRange.start;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).timeRange.end;
  }

  @override
  String getDescription(int index) {
    return _getMeetingData(index).description;
  }

  BookingModel getAppointments(int index) =>
      appointments![index] as BookingModel;
  BookingModel _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final BookingModel meetingData;
    if (meeting is BookingModel) {
      meetingData = meeting;
    }

    return meetingData;
  }
}
