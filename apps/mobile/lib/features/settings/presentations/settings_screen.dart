import 'package:api/api.dart';
import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/widgets/glass_list_tile.dart';
import 'package:mobile/features/auth/services/zoom_oauth_service.dart';
import 'package:mobile/features/home/widgets/general_drawer.dart';
import 'package:repositories/repositories.dart';
import 'package:util/util.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isZoomAuthenticating = false;

  Future<void> _signInToZoom() async {
    if (_isZoomAuthenticating) return;

    setState(() => _isZoomAuthenticating = true);
    try {
      final accessToken = await ZoomOAuthService().signIn();
      await ref
          .read(accessTokenNotifierProvider.notifier)
          .saveAccessToken(accessToken);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signed in to Zoom successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showFailureSnackBar(context, e.toString());
    } finally {
      if (mounted) {
        setState(() => _isZoomAuthenticating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            // GlassListTile(
            //   leading: Icon(
            //     Icons.notifications,
            //     size: 20,
            //     color: Colors.white.withOpac(0.9),
            //   ),
            //   title: const Text('Push Notifications'),
            //   subtitle: const Text('Receive alerts and updates'),
            //   isToggle: true,
            //   toggleValue: _notifications,
            //   onToggleChanged: (value) async {
            //     if (value) {
            //       final granted = await NotificationsController.instance
            //           .requestPermission();
            //       setState(() => _notifications = granted);
            //       await SettingsState.instance.setNotifications(granted);
            //     } else {
            //       setState(() => _notifications = false);
            //       await SettingsState.instance.setNotifications(false);
            //     }
            //   },
            // ),
            (ref.watch(accessTokenNotifierProvider).value == null)
                ? GlassListTile(
                    onTap: _isZoomAuthenticating ? null : _signInToZoom,
                    leading: Image.asset(
                      'assets/logo/zoom_cam.png',
                      width: 25,
                      height: 25,
                    ),
                    title: Row(
                      children: [
                        Text(_isZoomAuthenticating ? 'Signing In…' : 'Sign In'),
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
              borderTitle: 'Select Prayer Alter',
              title: DropdownButtonHideUnderline(
                child: DropdownButton<OrganizationsID>(
                  value: ref.watch(organizationControllerProvider).value,
                  isExpanded: true,
                  dropdownColor: Colors.black.withOpac(0.7),
                  borderRadius: BorderRadius.circular(12),

                  // placeholder
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Select Prayer Alter',
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
