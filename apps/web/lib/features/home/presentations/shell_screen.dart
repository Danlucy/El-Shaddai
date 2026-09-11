import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:website/core/widgets/glass_button.dart';
import 'package:website/features/auth/presentations/login_dialog.dart';

import '../../auth/controller/auth_controller.dart';

class ScaffoldWithNavBar extends ConsumerWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).value;
    final userName = user?.lastName ?? user?.name;
    final String currentLocation = navigationShell
        .shellRouteContext
        .routerState
        .uri
        .toString();

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: _RouteDrawer(
        currentLocation: currentLocation,
        navigationShell: navigationShell,
        user: user,
      ),
      appBar: AppBar(
        toolbarHeight: 60,
        key: ValueKey(userName),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          if (user != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Tooltip(
                message: 'View Profile',
                child: InkWell(
                  onTap: () {
                    navigationShell.goBranch(4);
                    context.go('/profile', extra: user);
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
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withOpac(0.2),
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

class _RouteDrawer extends StatelessWidget {
  const _RouteDrawer({
    required this.currentLocation,
    required this.navigationShell,
    required this.user,
  });

  final String currentLocation;
  final StatefulNavigationShell navigationShell;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      width: 280,
      backgroundColor: Colors.transparent,
      child: GlassmorphicContainer(
        width: 280,
        height: MediaQuery.sizeOf(context).height,
        borderRadius: 0,
        blur: 20,
        border: 0,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surface.withOpac(0.82),
            colorScheme.surface.withOpac(0.68),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            colorScheme.onSurface.withOpac(0.22),
            colorScheme.onSurface.withOpac(0.08),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            child: Column(
              children: [
                _DrawerRouteTile(
                  icon: Icons.house_outlined,
                  selectedIcon: Icons.house,
                  label: 'Home',
                  selected: currentLocation == '/',
                  onTap: () => _goToBranch(context, 0),
                ),
                _DrawerRouteTile(
                  icon: Icons.list_alt_outlined,
                  selectedIcon: Icons.list_alt,
                  label: 'Prayer Watch List',
                  selected: currentLocation.startsWith('/list'),
                  onTap: () => _goToBranch(context, 2),
                ),
                _DrawerRouteTile(
                  icon: Icons.calendar_month_outlined,
                  selectedIcon: Icons.calendar_month,
                  label: 'Calendar View',
                  selected: currentLocation.startsWith('/booking'),
                  onTap: () {
                    Navigator.of(context).pop();
                    navigationShell.goBranch(1);
                    context.go('/booking');
                  },
                ),
                _DrawerRouteTile(
                  icon: Icons.account_circle_outlined,
                  selectedIcon: Icons.account_circle,
                  label: 'Profile',
                  selected: currentLocation.startsWith('/profile'),
                  onTap: () {
                    Navigator.of(context).pop();
                    navigationShell.goBranch(4);
                    context.go('/profile', extra: user);
                  },
                ),
                const Spacer(),
                _DrawerRouteTile(
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings,
                  label: 'Settings',
                  selected: currentLocation.startsWith('/settings'),
                  onTap: () => _goToBranch(context, 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goToBranch(BuildContext context, int index) {
    Navigator.of(context).pop();
    navigationShell.goBranch(index);
  }
}

class _DrawerRouteTile extends StatelessWidget {
  const _DrawerRouteTile({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        leading: Icon(selected ? selectedIcon : icon),
        title: Text(label),
        selected: selected,
        selectedColor: colorScheme.primary,
        selectedTileColor: colorScheme.primary.withOpac(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onTap,
      ),
    );
  }
}
