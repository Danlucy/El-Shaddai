import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

/// Repository for users (scoped by current org if needed)
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
}
