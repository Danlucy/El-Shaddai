import 'package:el_shaddai/core/utility/date_time_range.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

@freezed
class BookingModel with _$BookingModel {
  const BookingModel._();
  const factory BookingModel({
    required String userId,
    required String eventId,
    @DateTimeRangeConverter() required DateTimeRange timeRange,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);
}
