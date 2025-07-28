import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mobile/api/models/access_token_model/access_token_model.dart';
import 'package:mobile/core/constants/constants.dart';
import 'package:mobile/core/widgets/snack_bar.dart';
import 'package:mobile/features/booking/presentations/booking_dialog.dart';

import '../../../core/router/router.dart';
import '../../../models/user_model/user_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/widgets/confirm_button.dart';
import '../../booking/presentations/booking_venues_component/booking_zoom_component.dart';

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
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Drawer(
      width: width,
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.house),
              title: const Text('Home'),
              onTap: () => const HomeRoute().push(context),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Book Prayer Watch'),
              onTap: () => const BookingRoute().push(context),
            ),
            ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Prayer List'),
                onTap: () => const BookingListRoute().push(context)),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Prayer Leaders'),
              onTap: () => const PrayerLeaderRoute().push(context),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () => ProfileRoute(user).push(context),
            ),
            (user?.role == UserRole.admin)
                ? ListTile(
                    leading: const Icon(Icons.supervisor_account),
                    title: const Text('User Management'),
                    onTap: () => const UserManagementRoute().push(context),
                  )
                : const SizedBox(),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('About Us'),
              onTap: () => const AboutUsRoute().push(context),
            ),
            const Spacer(),
            //change7
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
                        Text('Sign In'),
                        Gap(5),
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
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
