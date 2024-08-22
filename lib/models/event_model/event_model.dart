import 'package:el_shaddai/core/utility/date_time_range.dart';
import 'package:el_shaddai/core/utility/json_converters.dart';
import 'package:el_shaddai/models/location_data.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@freezed
class EventModel with _$EventModel {
  const EventModel._();
  const factory EventModel(
      {required String title,
      required String hostId,
      @DateTimeRangeConverter() required DateTimeRange timeRange,
      required String userId,
      required String id,
      @LocationDataConverter() required LocationData location,
      required String description}) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}
