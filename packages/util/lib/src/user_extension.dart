import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

extension UserModelX on UserModel {
  UserRole currentRole(WidgetRef ref, {UserRole fallback = UserRole.observer}) {
    final orgAsync = ref.watch(organizationControllerProvider);

    return orgAsync.when(
      data: (org) {
        return roles[org.name] ?? fallback;
      },
      loading: () => fallback,
      error: (_, __) => fallback,
    );
  }

  UserRole getRoleForOrg(
    String orgId, {
    UserRole fallback = UserRole.observer,
  }) {
    return roles[orgId] ?? fallback;
  }

  UserModel assignRoleForOrg(String orgId, UserRole role) {
    final updated = {...roles, orgId: role};
    return copyWith(roles: updated);
  }

  String roleDisplayName(WidgetRef ref) {
    final role = currentRole(ref);
    return role.displayName;
  }

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
