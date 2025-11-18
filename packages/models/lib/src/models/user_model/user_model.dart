import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:util/util.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
sealed class UserModel with _$UserModel {
  const factory UserModel({
    required String name,
    required String uid,
    @Default({}) Map<String, UserRole> roles,

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

  /// 🧭 Firestore field keys (for clean referencing)
  static const fields = _UserFields();
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

/// Separate immutable const class to hold all field names
class _UserFields {
  const _UserFields();

  final String name = 'name';
  final String uid = 'uid';
  final String roles = 'roles';
  final String createdAt = 'createdAt';
  final String lastName = 'lastName';
  final String image = 'image';
  final String nationality = 'nationality';
  final String phoneNumber = 'phoneNumber';
  final String description = 'description';
  final String address = 'address';
  final String birthAddress = 'birthAddress';
  final String church = 'church';
  final String beleifInGod = 'beleifInGod';
  final String prayerNetwork = 'prayerNetwork';
  final String definitionOfGod = 'definitionOfGod';
  final String godsCalling = 'godsCalling';
  final String recommendation = 'recommendation';
  final String fcmToken = 'fcmToken';
}
