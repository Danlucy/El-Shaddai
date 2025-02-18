import 'package:el_shaddai/features/user_management/repository/user_management_repository.dart';
import 'package:el_shaddai/models/user_model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_management_controller.g.dart';

@riverpod
class UserManagementController extends _$UserManagementController {
  @override
  void build() {}

  void deleteUser(String uid) {
    final repository = ref.read(userManagementRepositoryProvider);
    repository.deleteUser(uid);
  }

  void changeUserRole(String uid, UserRole role) {
    final repository = ref.read(userManagementRepositoryProvider);
    repository.updateUserRole(role, uid);
  }
}
