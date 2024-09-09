import 'dart:convert';

import 'package:el_shaddai/api/models/recurrence_configuration_model.dart';
import 'package:el_shaddai/core/utility/json_converters.dart';
import 'package:el_shaddai/features/booking/state/booking_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'zoom_meeting_model.freezed.dart';
part 'zoom_meeting_model.g.dart';

@freezed
class ZoomMeetingModel with _$ZoomMeetingModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const ZoomMeetingModel._();

  factory ZoomMeetingModel({
    required String topic,
    @JsonKey(
      name: 'agenda',
    )
    required String description,
    @RecurrenceConfigurationConverter()
    @JsonKey(name: 'recurrence')
    RecurrenceConfigurationModel? recurrenceConfiguration,
    required DateTime startTime,
    @JsonKey(
      defaultValue: 2,
    )
    required int type,
  }) = _ZoomMeetingModel;

  factory ZoomMeetingModel.fromJson(Map<String, dynamic> json) =>
      _$ZoomMeetingModelFromJson(json);
}
