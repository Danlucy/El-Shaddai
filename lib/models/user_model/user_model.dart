import 'package:el_shaddai/core/utility/date_time_range.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_model.g.dart';
part 'user_model.freezed.dart';

@freezed
class UserModel with _$UserModel {
  @JsonSerializable(explicitToJson: true)
  const UserModel._();
  const factory UserModel(
      {required String name,
      required String uid,
      required UserRole role,
      String? nationality,
      String? phoneNumber,
      String? description,
      String? church,
      String? address,
      @DateTimeRangeConverter() DateTime? birthday}) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

enum UserRole {
  admin,
  watchman,
  intercessor;

  static UserRole? fromName(String name) {
    for (UserRole enumVariant in UserRole.values) {
      if (enumVariant.name == name) return enumVariant;
    }
    return null;
  }
}
