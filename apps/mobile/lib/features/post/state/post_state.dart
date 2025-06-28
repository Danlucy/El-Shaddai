import 'package:freezed_annotation/freezed_annotation.dart';
part 'post_state.g.dart';

part 'post_state.freezed.dart';

@freezed
class PostState with _$PostState {
  const PostState._();

  const factory PostState({
    String? title,
    String? description,
    List<int>? image,
  }) = _PostState;
  factory PostState.fromJson(Map<String, dynamic> json) =>
      _$PostStateFromJson(json);
}
