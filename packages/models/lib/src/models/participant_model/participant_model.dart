import 'package:freezed_annotation/freezed_annotation.dart';

part 'participant_model.freezed.dart';
part 'participant_model.g.dart';

@freezed
sealed class ParticipantModel with _$ParticipantModel {
  const ParticipantModel._();
  const factory ParticipantModel({
    required String bookingId,
    required List<String> participantsId,
  }) = _ParticipantModel;

  factory ParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$ParticipantModelFromJson(json);
}
