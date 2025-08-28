import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:util/util.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
sealed class UserModel with _$UserModel {
  const factory UserModel({
    required String name,
    required String uid,
    required Map<String, UserRole> roles,
    @TimestampConverter() required DateTime createdAt,
    String? lastName,
    List<int>? image,
    String? nationality,
    String? phoneNumber,
    String? description,
    String? address,
    String? birthAddress,
    String? church,
    String? beleifInGod,
    String? prayerNetwork,
    String? definitionOfGod,
    String? godsCalling,
    String? recommendation,
    String? fcmToken,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

enum UserRole {
  admin(displayName: 'Admin'),
  watchman(displayName: 'Watchman'),
  watchLeader(displayName: 'Watch Leader'),
  intercessor(displayName: 'Intercessor'),
  observer(displayName: 'Observer');

  const UserRole({required this.displayName});
  final String displayName;
}
