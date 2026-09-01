import 'package:api/api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:util/util.dart';

void main() {
  test('generates the callable contract without server-owned fields', () {
    final recurrence = RecurrenceConfigurationModel(
      recurrenceFrequency: 3,
      weeklyDays: null,
      type: 1,
      recurrenceInterval: 1,
    );
    final request = BookingDTO(
      requestId: 'request-1',
      organizationId: 'church-1',
      isUpdating: false,
      bookingId: null,
      timezoneOffsetMinutes: 480,
      title: 'Morning prayer',
      recurrenceState: RecurrenceState.daily,
      host: 'Host',
      timeRange: CustomDateTimeRange(
        start: DateTime.utc(2026, 8, 2, 1),
        end: DateTime.utc(2026, 8, 2, 2),
      ),
      location: LocationData(address: 'Main hall'),
      description: 'Daily gathering',
      password: null,
      recurrence: recurrence,
      zoomOccurrences: [
        BookingSubmissionZoomOccurrence.fromZoomResponse({
          'occurrence_id': 12345,
        }),
      ],
    );

    expect(request.toCallableData(), {
      'requestId': 'request-1',
      'organizationId': 'church-1',
      'isUpdating': false,
      'bookingId': null,
      'timezoneOffsetMinutes': 480,
      'title': 'Morning prayer',
      'recurrenceState': 'daily',
      'host': 'Host',
      'timeRange': {
        'start': DateTime.utc(2026, 8, 2, 1).millisecondsSinceEpoch,
        'end': DateTime.utc(2026, 8, 2, 2).millisecondsSinceEpoch,
      },
      'location': {'address': 'Main hall', 'web': null, 'chords': null},
      'description': 'Daily gathering',
      'password': null,
      'recurrence': {
        'end_times': 3,
        'weekly_days': null,
        'type': 1,
        'repeat_interval': 1,
      },
      'zoomOccurrences': [
        {'occurrence_id': '12345'},
      ],
    });

    final callableData = request.toCallableData();
    expect(callableData, isNot(contains('userId')));
    expect(callableData, isNot(contains('createdAt')));
    expect(callableData, isNot(contains('id')));
    expect(callableData, isNot(contains('groupId')));
    expect(callableData, isNot(contains('occurrenceId')));
  });
}
