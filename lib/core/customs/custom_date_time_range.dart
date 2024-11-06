import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class CustomDateTimeRangeConverter
    implements JsonConverter<CustomDateTimeRange, Map<String, dynamic>> {
  const CustomDateTimeRangeConverter();
  @override
  CustomDateTimeRange fromJson(Map<String, dynamic> json) {
    if (json['start'] is Timestamp) {
      return CustomDateTimeRange(
          start: (json['start'] as Timestamp).toDate(),
          end: (json['end'] as Timestamp).toDate());
    } else {
      return CustomDateTimeRange(start: json['start'], end: json['end']);
    }
  }

  @override
  Map<String, DateTime> toJson(CustomDateTimeRange object) {
    return {'start': object.start, 'end': object.end};
  }
}

class CustomDateTimeRange {
  /// Creates a date range for the given start and end [DateTime].
  CustomDateTimeRange({
    required this.start,
    required this.end,
  });

  /// The start of the range of dates.
  final DateTime start;

  /// The end of the range of dates.
  final DateTime end;

  /// Returns a [Duration] of the time between [start] and [end].
  ///
  /// See [DateTime.difference] for more details.
  Duration get duration => end.difference(start);

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is CustomDateTimeRange &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => '$start - $end';
}
