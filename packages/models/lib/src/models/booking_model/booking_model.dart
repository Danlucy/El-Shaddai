import 'package:api/api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:util/util.dart';

import '../location_data.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

enum RecurrenceState {
  none,
  daily,
  weekly;

  static RecurrenceState? fromName(String name) {
    for (RecurrenceState enumVariant in RecurrenceState.values) {
      if (enumVariant.name == name) return enumVariant;
    }
    return null;
  }
}

@freezed
sealed class BookingModel with _$BookingModel {
  const BookingModel._();
  const factory BookingModel({
    required String title,
    @CustomDateTimeRangeConverter() required RecurrenceState recurrenceState,
    required String host,
    required DateTime createdAt,
    @CustomDateTimeRangeConverter() required CustomDateTimeRange timeRange,
    required String userId,
    required String id,
    @LocationDataConverter() required LocationData location,
    required String description,
    String? password,
    @RecurrenceConfigurationConverter()
    RecurrenceConfigurationModel? recurrenceModel,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);
}
