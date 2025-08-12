import 'package:repositories/repositories.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_management_controller.g.dart';

@riverpod
class UserManagementController extends _$UserManagementController {
  @override
  void build() {}

  void changeUserRole(String uid, String role) {
    final repository = ref.read(userManagementRepositoryProvider);
    repository.updateUserRole(role, uid);
  }
}
