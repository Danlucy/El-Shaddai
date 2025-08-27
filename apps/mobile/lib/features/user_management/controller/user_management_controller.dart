import 'package:mobile/features/user_management/provider/user_management_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_management_controller.g.dart';

@Riverpod(keepAlive: true)
class UserManagementController extends _$UserManagementController {
  @override
  void build() {}

  void changeUserRole(String uid, String role) {
    ref
        .read(currentUserManagementRepositoryProvider)
        .updateUserRole(uid: uid, role: role);
  }
}
