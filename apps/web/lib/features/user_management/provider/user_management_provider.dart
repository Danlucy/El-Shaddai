import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_management_provider.g.dart';

final currentUserManagementRepositoryProvider =
    Provider<UserManagementRepository>((ref) {
      final currentOrg = ref.watch(organizationControllerProvider);

      return currentOrg.when(
        data: (org) =>
            ref.watch(userManagementRepositoryProvider(org.name)), // ✅ OK
        loading: () => throw StateError('Organization not loaded'),
        error: (err, stack) => throw err,
      );
    });
@riverpod
AsyncValue<List<UserModel>> usersByRole(
  Ref ref, {
  UserRole? role,
  String searchTerm = '',
}) {
  final orgAsync = ref.watch(organizationControllerProvider);
  return orgAsync.when(
    data: (org) {
      // print('tracl2');
      // print(
      //   ref.watch(
      //     usersByRoleForOrgProvider(
      //       orgId:
      //           org.name, // 👈 use org.id (not .name) if that’s your unique key
      //       role: role,
      //       searchTerm: searchTerm,
      //     ),
      //   ),
      // );
      return ref.watch(
        usersByRoleForOrgProvider(
          orgId:
              org.name, // 👈 use org.id (not .name) if that’s your unique key
          role: role,
          searchTerm: searchTerm,
        ),
      );
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) {
      return AsyncValue.error(err, stack);
    },
  );
}
