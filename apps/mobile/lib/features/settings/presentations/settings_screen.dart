import 'package:api/api.dart';
import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/organization/controller/organization_controller.dart';
import 'package:mobile/core/router/router.dart';
import 'package:mobile/core/widgets/glass_list_tile.dart';
import 'package:mobile/features/home/widgets/general_drawer.dart';
import 'package:mobile/features/notifications/controller/notifications_controller.dart';
import 'package:mobile/features/settings/state/settings_state.dart';
import 'package:util/util.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final SettingsState _settings = SettingsState.instance;

  bool _isLoading = true;
  bool _notifications = false;
  Future<void> _loadSettings() async {
    await _settings.init(); // Initialize SharedPreferences

    setState(() {
      _notifications = _settings.getNotifications();
      _isLoading = false;
    });
  }

  Future<void> _updateSetting(String settingName, bool value) async {
    switch (settingName) {
      case 'notifications':
        if (value) {
          // Request permission
          bool granted = await NotificationsController.instance
              .requestPermission();

          // Only turn toggle on if permission granted
          if (granted) {
            setState(() => _notifications = true);
            await _settings.setNotifications(true);
          } else {
            setState(() => _notifications = false); // show toggle as off
            await _settings.setNotifications(false);
          }
        } else {
          // User manually toggled off
          setState(() => _notifications = false);
          await _settings.setNotifications(false);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (_isLoading) {
    //   return const Scaffold(
    //     backgroundColor: Color(0xFF0F1115),
    //     body: Center(child: CircularProgressIndicator()),
    //   );
    // }
    return Scaffold(
      drawer: const GeneralDrawer(),
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              GoRouter.of(context).pop(); // Use GoRouter.of(context).pop()
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GlassListTile(
              leading: Icon(
                Icons.notifications,
                size: 20,
                color: Colors.white.withOpac(0.9),
              ),
              title: const Text('Push Notifications'),
              subtitle: const Text('Receive alerts and updates'),
              isToggle: true,
              toggleValue: _notifications,
              onToggleChanged: (value) async {
                if (value) {
                  final granted = await NotificationsController.instance
                      .requestPermission();
                  setState(() => _notifications = granted);
                  await SettingsState.instance.setNotifications(granted);
                } else {
                  setState(() => _notifications = false);
                  await SettingsState.instance.setNotifications(false);
                }
              },
            ),
            (ref.watch(accessTokenNotifierProvider).value == null)
                ? GlassListTile(
                    onTap: () {
                      try {
                        const ZoomRoute(zoomLoginRoute).push(context);
                      } catch (e, s) {
                        showFailureSnackBar(
                          context,
                          e.toString() + s.toString(),
                        );
                      }
                    },
                    leading: Image.asset(
                      'assets/logo/zoom_cam.png',
                      width: 25,
                      height: 25,
                    ),
                    title: Row(
                      children: [
                        const Text('Sign In'),
                        const Gap(5),
                        Image.asset(
                          'assets/logo/zoom.png',
                          width: 70,
                          height: 30,
                        ),
                      ],
                    ),
                  )
                : GlassListTile(
                    leading: Image.asset(
                      'assets/logo/zoom_cam.png',
                      width: 25,
                      height: 25,
                    ),
                    title: Row(
                      children: [
                        Text(
                          'Log Out',
                          style: TextStyle(color: context.colors.error),
                        ),
                        const Gap(5),
                        Image.asset(
                          'assets/logo/zoom.png',
                          width: 70,
                          height: 30,
                        ),
                      ],
                    ),
                    onTap: () {
                      ref
                          .read(accessTokenNotifierProvider.notifier)
                          .clearAccessToken();
                    },
                  ),
            GlassListTile(
              title: DropdownButtonHideUnderline(
                child: DropdownButton<OrganizationsID>(
                  value: ref.watch(organizationControllerProvider).value,
                  isExpanded: true,
                  dropdownColor: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),

                  // placeholder
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Select an Organization',
                      style: TextStyle(
                        fontSize: 16,
                        color: context.colors.primary,
                      ),
                    ),
                  ),

                  // change org
                  onChanged: (OrganizationsID? newValue) {
                    if (newValue != null) {
                      ref
                          .read(organizationControllerProvider.notifier)
                          .updateOrg(newValue);
                    }
                  },

                  // menu items
                  items: OrganizationsID.values.map((org) {
                    return DropdownMenuItem(
                      value: org,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          org.displayName,
                          style: TextStyle(
                            fontSize: 16,
                            color: context.colors.primary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
