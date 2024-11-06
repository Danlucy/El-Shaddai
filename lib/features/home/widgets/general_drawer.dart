import 'package:el_shaddai/core/router/router.dart';
import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/features/auth/repository/auth_repository.dart';
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
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.house),
              title: const Text('I Love You Mom'),
              onTap: () {
                const HomeRoute().push(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Prayer Watch'),
              onTap: () {
                const EventsRoute().push(context);
              },
            ),
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
              onTap: () {},
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.transit_enterexit_sharp),
              title: Text(
                'Log out',
                style: TextStyle(color: context.colors.error),
              ),
              onTap: () {
                showDialog(
                    barrierColor: Colors.black.withOpacity(0.2),
                    context: context,
                    builder: (context) {
                      return Center(
                        child: Container(
                          width: width * 3 / 4,
                          height: height * 1 / 4,
                          decoration: BoxDecoration(
                              color: context.colors.secondaryContainer,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Confirm Log Out?',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              context.colors.onSurfaceVariant),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                            color: context.colors.onSurface),
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent),
                                    onPressed: () {
                                      ref.read(authRepositoryProvider).logout();
                                    },
                                    child: Text(
                                      'Confirm',
                                      style: TextStyle(
                                          color: context.colors.onSurface),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
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
