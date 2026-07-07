import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:go_router/go_router.dart';
import 'package:website/core/widgets/glass_button.dart';
import 'package:website/features/auth/presentations/login_dialog.dart';

import '../../auth/controller/auth_controller.dart';

class ScaffoldWithNavBar extends ConsumerWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName =
        ref.watch(userProvider).value?.lastName ??
        ref.watch(userProvider).value?.name;
    final String currentLocation = navigationShell
        .shellRouteContext
        .routerState
        .uri
        .toString();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 60,
        key: ValueKey(userName),
        backgroundColor: Colors.transparent,
        elevation: 0,
        // ✅ Replace plain IconButton with PopupMenuButton
        leading: PopupMenuButton<String>(
          onSelected: (String value) {
            // Use navigationShell instead of context.go()
            switch (value) {
              case '/':
                navigationShell.goBranch(0);
                break;
              case '/booking':
                navigationShell.goBranch(1);
                context.go('/booking');
                break;
              case '/list':
                navigationShell.goBranch(2);
                break;
              case '/settings':
                navigationShell.goBranch(3);
                break;
              case '/profile':
                final user = ref.read(userProvider).value;
                if (user != null) {
                  navigationShell.goBranch(4);
                  context.go('/profile', extra: user);
                }
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: '/',
              child: ListTile(
                leading: Icon(
                  Icons.home,
                  color: currentLocation == '/'
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                title: Text(
                  'Home',
                  style: TextStyle(
                    color: currentLocation == '/'
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: '/booking',
              child: ListTile(
                leading: Icon(
                  Icons.calendar_today,
                  color: currentLocation == '/booking'
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                title: Text(
                  'Calendar View',
                  style: TextStyle(
                    color: currentLocation == '/booking'
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: '/list',
              child: ListTile(
                leading: Icon(
                  Icons.list,
                  color: currentLocation == '/list'
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                title: Text(
                  'Prayer Watch List',
                  style: TextStyle(
                    color: currentLocation == '/list'
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: '/settings',
              child: ListTile(
                leading: Icon(
                  Icons.settings,
                  color: currentLocation == '/settings'
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                title: Text(
                  'Settings',
                  style: TextStyle(
                    color: currentLocation == '/settings'
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                ),
              ),
            ),
            if (ref.watch(userProvider).value != null)
              PopupMenuItem<String>(
                value: '/profile',
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: currentLocation.startsWith('/profile')
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  title: Text(
                    'Profile',
                    style: TextStyle(
                      color: currentLocation.startsWith('/profile')
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: Text('Welcome ${userName ?? ''}'),
        flexibleSpace: GlassmorphicContainer(
          width: double.infinity,
          height: 120,
          borderRadius: 0,
          blur: 15,
          border: 0,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface.withOpac(0.1),
              Theme.of(context).colorScheme.surface.withOpac(0.05),
            ],
            stops: const [0.1, 1],
          ),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.onSurface.withOpac(0.2),
              Theme.of(context).colorScheme.onSurface.withOpac(0.2),
            ],
          ),
        ),
        actions: [
          if (ref.watch(userProvider.notifier).isLoggedIn)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Tooltip(
                message: 'View Profile',
                child: InkWell(
                  onTap: () {
                    final user = ref.read(userProvider).value;
                    if (user != null) {
                      navigationShell.goBranch(4);
                      context.go('/profile', extra: user);
                    }
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: currentLocation.startsWith('/profile')
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white.withOpac(0.3),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor:
                          Theme.of(context).colorScheme.primary.withOpac(0.2),
                      child: Icon(
                        Icons.person,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              child: GlassmorphicButton(
                constraints: const BoxConstraints(maxWidth: 180),
                text: 'Log In',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return GlassLoginDialog();
                    },
                  );
                },
                icon: Icons.key,
              ),
            ),
        ],
      ),
      body: navigationShell,
    );
  }
}
