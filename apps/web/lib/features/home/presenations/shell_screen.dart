import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:go_router/go_router.dart';
import 'package:website/core/widgets/glass_button.dart';
import 'package:website/features/auth/presentations/login_dialog.dart';

import '../../auth/controller/auth_controller.dart';

class ScaffoldWithNavBar extends ConsumerWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(index, initialLocation: true);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName =
        ref.watch(userProvider)?.lastName ?? ref.watch(userProvider)?.name;
    final int currentIndex = navigationShell.currentIndex;
    final String currentLocation =
        navigationShell.shellRouteContext.routerState.uri.toString();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
                break;
              case '/list':
                navigationShell.goBranch(2);
                // This one can use context.go since it's in the same branch
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: '/',
              child: ListTile(
                leading: Icon(Icons.home,
                    color: currentLocation == '/'
                        ? Theme.of(context).colorScheme.primary
                        : null),
                title: Text('Home',
                    style: TextStyle(
                        color: currentLocation == '/'
                            ? Theme.of(context).colorScheme.primary
                            : null)),
              ),
            ),
            PopupMenuItem<String>(
              value: '/booking',
              child: ListTile(
                leading: Icon(Icons.calendar_today,
                    color: currentLocation == '/booking'
                        ? Theme.of(context).colorScheme.primary
                        : null),
                title: Text('Event Calendar',
                    style: TextStyle(
                        color: currentLocation == '/booking'
                            ? Theme.of(context).colorScheme.primary
                            : null)),
              ),
            ),
            PopupMenuItem<String>(
              value: '/list',
              child: ListTile(
                leading: Icon(Icons.list,
                    color: currentLocation == '/list'
                        ? Theme.of(context).colorScheme.primary
                        : null),
                title: Text('Booking List',
                    style: TextStyle(
                        color: currentLocation == '/list'
                            ? Theme.of(context).colorScheme.primary
                            : null)),
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
              Theme.of(context).colorScheme.surface.withOpacity(0.1),
              Theme.of(context).colorScheme.surface.withOpacity(0.05),
            ],
            stops: const [0.1, 1],
          ),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            ],
          ),
        ),
        // ✅ Right side empty
        actions: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 4),
            child: GlassmorphicButton(
              constraints: const BoxConstraints(maxWidth: 180),
              text: userName == null ? 'Log In' : 'Log Out',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return GlassLoginDialog(
                      onGoogleSignIn: () {
                        print('Google Sign In Tapped');
                        // Add your Google sign-in logic here
                      },
                      onAppleSignIn: () {
                        print('Apple Sign In Tapped');
                        // Add your Apple sign-in logic here
                      },
                    );
                  },
                );
              },
              icon: Icons.key,
            ),
          )
        ],
      ),
      body: navigationShell,
    );
  }
}
