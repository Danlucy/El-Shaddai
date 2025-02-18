import 'package:el_shaddai/api/models/recurrence_configuration_model/recurrence_configuration_model.dart';
import 'package:el_shaddai/core/customs/custom_date_time_range.dart';
import 'package:el_shaddai/core/utility/json_converters.dart';
import 'package:el_shaddai/features/booking/state/booking_state.dart';
import 'package:el_shaddai/models/location_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

@freezed
class BookingModel with _$BookingModel {
  const BookingModel._();
  const factory BookingModel(
      {required String title,
      @CustomDateTimeRangeConverter() required RecurrenceState recurrenceState,
      required String host,
      required DateTime createdAt,
      @CustomDateTimeRangeConverter() required CustomDateTimeRange timeRange,
      required String userId,
      required String id,
      @LocationDataConverter() required LocationData location,
      required String description,
      @RecurrenceConfigurationConverter()
      RecurrenceConfigurationModel? recurrenceModel}) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);
}
