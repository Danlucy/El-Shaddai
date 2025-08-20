import 'package:api/api.dart';
import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/router/router.dart';
import 'package:util/util.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
            ListTile(title: Text('Notification')),
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
                        ),
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
          ],
        ),
      ),
    );
  }
}
