import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'organization_controller.g.dart';

enum OrganizationsID {
  elShaddai(displayName: 'EL Shaddai PA'),
  flamingFire(displayName: 'Flaming Fire KOG');

  const OrganizationsID({required this.displayName});
  final String displayName;
}

// The provider now automatically handles the async state
@riverpod
class OrganizationController extends _$OrganizationController {
  // 1. Make the build method async.
  // It now returns a Future<OrganizationsID>. Riverpod will manage the state.
  @override
  Future<OrganizationsID> build() async {
    // 2. Move your loading logic directly into build().
    final prefs = await SharedPreferences.getInstance();
    final lastOrgName = prefs.getString('currentOrg');
    if (lastOrgName != null) {
      // Find and return the saved enum value.
      return OrganizationsID.values.firstWhere(
        (e) => e.name == lastOrgName,
        // Provide a fallback if the saved value is somehow invalid.
        orElse: () => OrganizationsID.elShaddai,
      );
    }
    // 3. Return a default value if nothing was saved.
    return OrganizationsID.elShaddai;
  }

  // Your update method is perfect. The only change is how you handle the async state.
  Future<void> updateOrg(OrganizationsID orgId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentOrg', orgId.name);
    // 4. Update the state. Since the state is now an AsyncValue,
    // you wrap the new value in AsyncData().
    state = AsyncData(orgId);
  }
}
