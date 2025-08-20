import 'package:api/src/models/recurrence_configuration_model/recurrence_configuration_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:util/util.dart';

part 'zoom_meeting_model.freezed.dart';
part 'zoom_meeting_model.g.dart';

@freezed
sealed class ZoomMeetingModel with _$ZoomMeetingModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const ZoomMeetingModel._();

  factory ZoomMeetingModel({
    String? topic,
    @JsonKey(name: 'agenda') String? description,
    int? duration,
    String? password,
    @RecurrenceConfigurationConverter()
    @JsonKey(name: 'recurrence')
    RecurrenceConfigurationModel? recurrenceConfiguration,
    @JsonKey(name: 'start_time') required DateTime startTime,
    @JsonKey(defaultValue: 2) required int type,
    @JsonKey(name: 'default_password', defaultValue: false)
    required bool defaultPassword,
  }) = _ZoomMeetingModel;

  factory ZoomMeetingModel.fromJson(Map<String, dynamic> json) =>
      _$ZoomMeetingModelFromJson(json);
}
