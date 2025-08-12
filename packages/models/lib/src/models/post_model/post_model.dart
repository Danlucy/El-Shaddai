import 'package:freezed_annotation/freezed_annotation.dart';
part 'post_model.g.dart';
part 'post_model.freezed.dart';

@freezed
class PostModel with _$PostModel {
  const PostModel._();
  const factory PostModel({
    required String id,
    required String title,
    required String content,
    List<int>? image,
    required String userId,
    required DateTime createdAt,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}
