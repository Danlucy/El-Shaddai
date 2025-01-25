import 'package:el_shaddai/api/models/access_token_model/access_token_model.dart';
import 'package:el_shaddai/core/router/router.dart';
import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/features/auth/controller/auth_controller.dart';
import 'package:el_shaddai/features/auth/widgets/logout_button.dart';
import 'package:el_shaddai/models/user_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeneralDrawer extends ConsumerStatefulWidget {
  const GeneralDrawer({
    super.key,
  });

  @override
  ConsumerState<GeneralDrawer> createState() => _GeneralDrawerState();
}

class _GeneralDrawerState extends ConsumerState<GeneralDrawer> {
  final height = 600.0;
  final width = 300.0;
  @override
  Widget build(BuildContext context) {
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
              leading: const Icon(Icons.message),
              title: const Text('Prayer Watch'),
              onTap: () => const BookingRoute().push(context),
            ),
            ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Prayer List'),
                onTap: () => const BookingListRoute().push(context)),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Prayer Leader'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Contact Us'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () => const ProfileRoute().push(context),
            ),
            (ref.watch(userProvider)?.role == UserRole.admin)
                ? ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: const Text('User Management'),
                    onTap: () => const UserManagementRoute().push(context),
                  )
                : const SizedBox(),
            const Spacer(),
            (ref.watch(accessTokenNotifierProvider).value == null)
                ? const SizedBox()
                : ListTile(
                    leading: const Icon(Icons.account_circle),
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
                      return LogOutButton(
                          width: width, height: height, ref: ref);
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
