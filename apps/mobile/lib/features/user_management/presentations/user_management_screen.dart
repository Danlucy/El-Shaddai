import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:util/util.dart';

import '../../../core/router/router.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/widgets/confirm_button.dart';
import '../../home/widgets/general_drawer.dart';
import '../controller/user_management_controller.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(userManagementControllerProvider.notifier);

    // Use a DefaultTabController to manage the TabBar and TabBarView state
    return DefaultTabController(
      length: UserRole.values.length, // Number of tabs equals number of roles
      child: Scaffold(
        drawer: const GeneralDrawer(),
        appBar: AppBar(
          title: const Text('User Management'),
          // The TabBar is now part of the AppBar
          bottom: TabBar(
            isScrollable: true,
            tabs: UserRole.values.map((role) {
              return Tab(text: role.displayName);
            }).toList(),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: "Search Users",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  setState(() {}); // Refresh state when search changes
                },
              ),
            ),
            // The TabBarView displays the content for each tab
            Expanded(
              child: TabBarView(
                children: UserRole.values.map((role) {
                  // For each role, we create a new list of users
                  final users = ref.watch(usersByRoleProvider(
                      role: role, searchTerm: _searchController.text));

                  // FIX: Corrected syntax to use the .when() method on the stream
                  return users.when(
                      data: (data) {
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final user = data[index];
                            return ListTile(
                              onTap: () {
                                ProfileRoute(user).push(context);
                              },
                              title: Text(user.lastName ?? user.name),
                              subtitle: Text(user.role.displayName),
                              trailing: _PopMenuButton(
                                  user: user, controller: controller),
                            );
                          },
                        );
                      },
                      error: (x, s) {
                        return const Center(child: Text('Error loading users'));
                      },
                      loading: () => const CircularProgressIndicator());
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PopMenuButton extends ConsumerWidget {
  const _PopMenuButton({
    required this.user,
    required this.controller,
  });

  final UserModel user;

  final UserManagementController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          child: const Row(children: [
            Icon(
              Icons.supervised_user_circle_sharp,
              size: 20,
            ),
            Gap(5),
            Text('Role ')
          ]),
          onTap: () {
            _showChangeRoleDialog(context);
          },
        ),
        PopupMenuItem(
          child: const Row(children: [
            Icon(
              Icons.delete_forever,
              size: 20,
            ),
            Gap(5),
            Text('Delete ')
          ]),
          onTap: () {
            if (user.role == UserRole.admin) {
              showFailureSnackBar(context, 'You cannot delete an admin user');
              return;
            } else {
              showDialog(
                barrierColor: Colors.black.withOpac(0.3),
                context: context,
                builder: (context) {
                  return ConfirmButton(
                    confirmText: 'Delete',
                    cancelText: 'Cancel',
                    description: 'Delete User? This cannot be reverted.',
                    confirmAction: () {
                      ref
                          .read(authControllerProvider.notifier)
                          .deleteUser(user.uid, context);
                      context.pop();
                    },
                  );
                },
              );
            }
          },
        ),
      ],
      icon: const Icon(Icons.more_vert), // Three-dot menu icon
    );
  }

  void _showChangeRoleDialog(BuildContext context) {
    UserRole selectedRole = user.role; // Track selected role

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpac(0.5), // Dim background
      barrierDismissible: true, // Dismiss when tapping outside
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return GestureDetector(
              behavior:
                  HitTestBehavior.opaque, // Allow taps outside to close dialog
              onTap: () => context.pop(), // Close dialog when tapped outside
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {}, // Prevent taps inside from closing the dialog
                    child: ToggleButtons(
                      direction: Axis.vertical,
                      isSelected: UserRole.values
                          .map((role) => role == selectedRole)
                          .toList(),
                      onPressed: (index) {
                        setState(() {
                          selectedRole =
                              UserRole.values[index]; // Update selected role
                        });

                        controller.changeUserRole(user.uid, selectedRole.name);
                        context.pop(); // Close dialog after selection
                      },
                      borderRadius: BorderRadius.circular(10),
                      selectedColor: Colors.white,
                      fillColor: Theme.of(context).primaryColor,
                      children: UserRole.values.map((role) {
                        bool isSelected =
                            role == selectedRole; // Check selection
                        return Container(
                            color: isSelected
                                ? Colors.transparent
                                : Colors.black.withOpac(0.4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Text(
                              role.displayName.capitalize(),
                            ));
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
