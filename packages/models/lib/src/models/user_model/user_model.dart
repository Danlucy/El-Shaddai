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

extension UserModelFieldLabels on UserModel {
  static const Map<String, String> fieldLabels = {
    'lastName': 'Full Name.',
    'nationality': 'Nationality.',
    'phoneNumber': 'Phone Number.',
    'description': 'Introduce yourself as in personality.',
    'church': 'Church Name.',
    'address': 'Residence Address.',
    'birthAddress': 'Birth Place.',
    'prayerNetwork': 'Prayer Network you are involved with.',
    'beleifInGod':
        'Do you believe in God the Father, Jesus Christ the son and Holy Spirit? Yes/No.',
    'definitionOfGod': 'What is your definition of The Kingdom of God?',
    'godsCalling': "Share with us the calling God has for you.",
    'recommendation':
        'Who recommended you to join EL Shaddai 247 Prayer Altar for the Kingdom of God?',
  };

  /// ✅ Method to get the label for a given field
  static String getLabel(String fieldName) {
    return fieldLabels[fieldName] ?? fieldName;
  }
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
