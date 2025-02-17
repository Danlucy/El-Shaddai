import 'package:freezed_annotation/freezed_annotation.dart';
part 'participant_state.g.dart';

part 'participant_state.freezed.dart';

@freezed
class ParticipantState with _$ParticipantState {
  const ParticipantState._();

  const factory ParticipantState({
    String? userId,
    String? bookingId,
  }) = _ParticipantState;
  factory ParticipantState.fromJson(Map<String, dynamic> json) =>
      _$ParticipantStateFromJson(json);
}
