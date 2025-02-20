import 'package:el_shaddai/core/utility/date_time_range.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_model.g.dart';
part 'user_model.freezed.dart';

@Freezed(toJson: true, fromJson: false)
@JsonSerializable(explicitToJson: true)
class UserModel with _$UserModel {
  const UserModel._();
  const factory UserModel({
    required String name,
    required String uid,
    required UserRole role,
    String? lastName,
    List<int>? image,
    String? nationality,
    String? phoneNumber,
    String? description,
    String? church,
    String? address,
    String? birthAddress,
    String? beleifInGod,
    String? prayerNetwork,
    String? definitionOfGod,
    String? godsCalling,
    String? recommendation,
    // @DateTimeRangeConverter() DateTime? birthday
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelFieldLabels on UserModel {
  static const Map<String, String> fieldLabels = {
    'lastName': 'Full Name',
    'nationality': 'Nationality',
    'phoneNumber': 'Phone Number',
    'description': 'Introduce yourself as in personality',
    'church': 'Church Name',
    'address': 'Residence Address',
    'birthAddress': 'Birth Place',
    'prayerNetwork': 'Prayer Network you are involved with',
    'beleifInGod':
        'Do you believe in God the Father, Jesus Christ the son and Holy Spirit? Yes/No',
    'definitionOfGod': 'What is your definition of Kingdom of God',
    'godsCalling': "Share with us the calling God has for you",
    'recommendation':
        'Who recommended you to join EL Shaddai 247 Prayer Altar for the Kingdom of God',
  };

  /// ✅ Method to get the label for a given field
  static String getLabel(String fieldName) {
    return fieldLabels[fieldName] ?? fieldName;
  }
}

enum UserRole {
  admin(name: 'Admin'),
  watchman(name: 'Watchman'),
  watchLeader(name: 'Watch Leader'),
  intercessor(name: 'Intercessor'),
  ;

  final String name;

  const UserRole({required this.name});
  static UserRole? fromName(String name) {
    for (UserRole enumVariant in UserRole.values) {
      if (enumVariant.name == name) return enumVariant;
    }
    return null;
  }
}
