import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
// extension_user_role.dart

extension UserRoleX on UserRole {
  // ✅ NOW 'this' refers to the UserRole (e.g., UserRole.admin)

  // ✅ 1. Admin Only
  bool get onlyAdmin => this == UserRole.admin;

  // ✅ 2. Watchman and Above
  // Includes: Admin, Watchman
  bool get isWatchLeaderOrHigher =>
      [UserRole.admin, UserRole.watchman, UserRole.watchLeader].contains(this);

  // ✅ 3. Special: Not Intercessor or Observer
  // Includes: Admin, Watchman, WatchLeader
  bool get isObserver => this == UserRole.observer;
  bool get isWatchmanOrHigher =>
      [UserRole.admin, UserRole.watchman].contains(this);

  // ✅ 4. Intercessor and Above (Commonly used for "Write" access vs Read-Only)
  // Includes: Admin, Watchman, WatchLeader, Intercessor
  // Excludes: Observer
  bool get isIntercessorOrHigher => [
    UserRole.admin,
    UserRole.watchman,
    UserRole.watchLeader,
    UserRole.intercessor,
  ].contains(this);
  // ✅ 5. Explicit "Not Intercessor or Observer" (As requested)
  bool get isNotIntercessorOrObserver =>
      this != UserRole.intercessor && this != UserRole.observer;
}

extension UserModelX on UserModel? {
  bool isHost(String userid) {
    // 1. Shadow 'this' to a local variable
    final user = this;

    // 2. Check the local variable
    if (user == null) return false;

    // 3. Dart KNOWS 'user' is not null now. No '!' needed!
    return userid == user.uid;
  }

  UserRole currentRole(WidgetRef ref) {
    final user = this; // Shadowing
    if (user == null) {
      return UserRole.observer;
    }

    final orgAsync = ref.watch(organizationControllerProvider);

    return orgAsync.when(
      data: (org) {
        // Safe access without '!'
        return user.roles[org.name] ?? UserRole.observer;
      },
      loading: () => UserRole.observer,
      error: (_, __) => UserRole.observer,
    );
  }

  UserRole getRoleForOrg(
    String orgId, {
    UserRole fallback = UserRole.observer,
  }) {
    final user = this; // Shadowing
    if (user == null) return fallback;

    return user.roles[orgId] ?? fallback;
  }

  UserModel? assignRoleForOrg(String orgId, UserRole role) {
    final user = this; // Shadowing
    if (user == null) return null;

    final updated = {...user.roles, orgId: role};
    return user.copyWith(roles: updated);
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
