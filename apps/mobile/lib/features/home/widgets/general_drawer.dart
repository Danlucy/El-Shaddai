import 'package:api/api.dart';
import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:util/util.dart';

import '../../../core/router/router.dart';
import '../../../core/widgets/glass_container.dart'; // Make sure you have this import
import '../../auth/controller/auth_controller.dart';
import '../../auth/widgets/confirm_button.dart';

class GeneralDrawer extends ConsumerStatefulWidget {
  const GeneralDrawer({
    super.key,
  });

  @override
  ConsumerState<GeneralDrawer> createState() => _GeneralDrawerState();
}

class _GeneralDrawerState extends ConsumerState<GeneralDrawer> {
  final height = 600.0;
  final width = 280.0;

  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion =
          'v${info.version}'; // Optionally: + ' (${info.buildNumber})'
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Drawer(
      width: width,
      // Step 1: Set the Drawer's background to transparent
      backgroundColor: Colors.transparent,
      child: GlassContainer(
        // Step 2: Use GlassContainer to apply the blur effect and semi-transparent background
        // GlassContainer's width and height should match the Drawer's dimensions
        width: width,
        height: double.infinity,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.house),
                title: const Text('Home'),
                onTap: () => const HomeRoute().push(context),
              ),
              ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text('Prayer Watch List'),
                  onTap: () => const BookingListRoute().push(context)),
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text('Book Prayer Watch'),
                onTap: () => const BookingRoute().push(context),
              ),

              ListTile(
                leading: const Icon(Icons.message),
                title: const Text('Watch Leaders'),
                onTap: () => const PrayerLeaderRoute().push(context),
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('My Profile'),
                onTap: () => ProfileRoute(user).push(context),
              ),
              if (user?.role == UserRole.admin)
                ListTile(
                  leading: const Icon(Icons.supervisor_account),
                  title: const Text('User Management'),
                  onTap: () => const UserManagementRoute().push(context),
                ),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('About Us'),
                onTap: () => const AboutUsRoute().push(context),
              ),
              const Spacer(),

              // Zoom sign in / out
              (ref.watch(accessTokenNotifierProvider).value == null)
                  ? ListTile(
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
                          )
                        ],
                      ),
                    )
                  : ListTile(
                      leading: const Icon(Icons.video_camera_front),
                      title: Text(
                        'Log out Zoom',
                        style: TextStyle(color: context.colors.error),
                      ),
                      onTap: () {
                        ref
                            .read(accessTokenNotifierProvider.notifier)
                            .clearAccessToken();
                      },
                    ),

              ListTile(
                trailing: Text(
                  _appVersion,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                leading: const Icon(Icons.transit_enterexit_sharp),
                title: Text(
                  'Log out',
                  style: TextStyle(color: context.colors.error),
                ),
                onTap: () {
                  showDialog(
                    barrierColor: Colors.black.withOpac(0.2),
                    context: context,
                    builder: (context) {
                      return ConfirmButton(
                        confirmText: 'Log out',
                        confirmAction: () {
                          ref.read(authControllerProvider.notifier).signOut();
                        },
                        description: 'Are you sure you want to log out?',
                        cancelText: 'Cancel',
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () => const AboutUsRoute().push(context),
              ),
              // 👇 App Version at bottom
            ],
          ),
        ),
      ),
    );
  }
}
