import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:time_range_picker/time_range_picker.dart';

class DateTimeRangeConverter
    implements JsonConverter<DateTimeRange, Map<String, dynamic>> {
  const DateTimeRangeConverter();
  @override
  DateTimeRange fromJson(Map<String, dynamic> json) {
    if (json['start'] is Timestamp) {
      return DateTimeRange(
          start: (json['start'] as Timestamp).toDate(),
          end: (json['end'] as Timestamp).toDate());
    } else {
      return DateTimeRange(start: json['start'], end: json['end']);
    }
  }

  @override
  Map<String, DateTime> toJson(DateTimeRange object) {
    return {'start': object.start, 'end': object.end};
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension DateTimeExtension on DateTime {
  DateTime get upToMinute => DateTime(year, month, day, minute);
  bool isAfterOrEqualTo(DateTime dateTime) {
    final date = this;
    final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
    return isAtSameMomentAs || date.isAfter(dateTime);
  }

  bool isBeforeOrEqualTo(DateTime dateTime) {
    final date = this;
    final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
    return isAtSameMomentAs || date.isBefore(dateTime);
  }

  bool isBetween(
    DateTime fromDateTime,
    DateTime toDateTime,
  ) {
    final date = this;
    final isAfter = date.isAfterOrEqualTo(fromDateTime);
    final isBefore = date.isBeforeOrEqualTo(toDateTime);
    return isAfter && isBefore;
  }

  DateTime setTimeOfDay(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }

  DateTime setTime(
    DateTime dateTime, {
    int hours = 0,
  }) {
    return DateTime(
      year,
      month,
      day,
    );
  }

  DateTime clearTime() {
    return DateTime(year, month, day, 0, 0, 0, 0, 0);
  }
}

List<DateTime> getDaysInBetweenIncludingStartEndDate(
    {required DateTime startDateTime, required DateTime endDateTime}) {
  // Converting dates provided to UTC
  // So that all things like DST don't affect subtraction and addition on dates
  DateTime startDateInUTC =
      DateTime.utc(startDateTime.year, startDateTime.month, startDateTime.day);
  DateTime endDateInUTC =
      DateTime.utc(endDateTime.year, endDateTime.month, endDateTime.day);

  // Created a list to hold all dates
  List<DateTime> daysInFormat = [];

  // Starting a loop with the initial value as the Start Date
  // With an increment of 1 day on each loop
  // With condition current value of loop is smaller than or same as end date
  for (DateTime i = startDateInUTC;
      i.isBefore(endDateInUTC) || i.isAtSameMomentAs(endDateInUTC);
      i = i.add(const Duration(days: 1))) {
    // Converting back UTC date to Local date if it was local before
    // Or keeping in UTC format if it was UTC

    if (startDateTime.isUtc) {
      daysInFormat.add(i);
    } else {
      daysInFormat.add(DateTime(i.year, i.month, i.day));
    }
  }
  return daysInFormat;
}
