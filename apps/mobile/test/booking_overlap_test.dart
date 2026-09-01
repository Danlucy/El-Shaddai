import 'package:flutter_test/flutter_test.dart';
import 'package:util/util.dart';

CustomDateTimeRange range(
  int startDay,
  int startHour,
  int endDay,
  int endHour,
) {
  return CustomDateTimeRange(
    start: DateTime(2026, 7, startDay, startHour),
    end: DateTime(2026, 7, endDay, endHour),
  );
}

void main() {
  group('findOverlappingDates', () {
    test('does not treat back-to-back bookings as overlapping', () {
      final dates = findOverlappingDates(
        candidateRanges: [range(3, 10, 3, 11)],
        existingRanges: [range(3, 9, 3, 10)],
      );

      expect(dates, isEmpty);
    });

    test('returns sorted unique calendar dates of the actual overlap', () {
      final dates = findOverlappingDates(
        candidateRanges: [range(5, 9, 5, 10), range(3, 9, 5, 10)],
        existingRanges: [range(4, 0, 6, 0), range(5, 9, 5, 11)],
      );

      expect(dates, [DateTime(2026, 7, 4), DateTime(2026, 7, 5)]);
    });
  });

  group('formatOverlappingDates', () {
    test('lists three dates without a suffix when there are only three', () {
      final message = formatOverlappingDates([
        DateTime(2026, 7, 5),
        DateTime(2026, 7, 3),
        DateTime(2026, 7, 4),
      ]);

      expect(message, '[3/7/26], [4/7/26], [5/7/26]');
    });

    test('lists the first three dates followed by and more', () {
      final message = formatOverlappingDates([
        DateTime(2026, 7, 6),
        DateTime(2026, 7, 3),
        DateTime(2026, 7, 5),
        DateTime(2026, 7, 4),
      ]);

      expect(message, '[3/7/26], [4/7/26], [5/7/26] and more');
    });
  });
}
