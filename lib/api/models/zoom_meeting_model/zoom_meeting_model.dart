import 'package:el_shaddai/api/models/recurrence_configuration_model/recurrence_configuration_model.dart';
import 'package:el_shaddai/core/utility/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'zoom_meeting_model.g.dart';
part 'zoom_meeting_model.freezed.dart';

@freezed
class ZoomMeetingModel with _$ZoomMeetingModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const ZoomMeetingModel._();

  factory ZoomMeetingModel({
    String? topic,
    @JsonKey(
      name: 'agenda',
    )
    String? description,
    int? duration,
    @RecurrenceConfigurationConverter()
    @JsonKey(name: 'recurrence')
    RecurrenceConfigurationModel? recurrenceConfiguration,
    @JsonKey(name: 'start_time') required DateTime startTime,
    @JsonKey(
      defaultValue: 2,
    )
    required int type,
  }) = _ZoomMeetingModel;

  factory ZoomMeetingModel.fromJson(Map<String, dynamic> json) =>
      _$ZoomMeetingModelFromJson(json);
}
