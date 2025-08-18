import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../auth/controller/auth_controller.dart';

class ScaffoldWithNavBar extends ConsumerWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(userProvider)?.lastName ?? '';
    final int currentIndex = navigationShell.currentIndex;
    final bool isSmallScreen =
        ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    return Scaffold(
      // Use extendBodyBehindAppBar to allow the body to go behind the glass app bar
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Must be transparent
        elevation: 0,
        leading:
            IconButton(onPressed: () {}, icon: const Icon(Icons.menu_sharp)),
        title: Text('Welcome $userName'),
        // Use flexibleSpace to place the glass container behind the AppBar content
        flexibleSpace: GlassmorphicContainer(
          width: double.infinity,
          height: 120, // Adjust height as needed
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
        // Re-integrated responsive navigation actions
        actions: [
          if (isSmallScreen)
            PopupMenuButton<int>(
              icon: const Icon(Icons.more_vert),
              onSelected: _onTap,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                _buildPopupMenuItem(
                    context, 'Home', Icons.home, 0, currentIndex),
                _buildPopupMenuItem(
                    context, 'Booking', Icons.calendar_today, 1, currentIndex),
                // Add other menu items here
              ],
            )
          else
            Row(
              children: [
                _buildTextButton(context, 'Home', Icons.home, 0, currentIndex),
                const SizedBox(width: 8),
                _buildTextButton(
                    context, 'Booking', Icons.calendar_today, 1, currentIndex),
                // Add other text buttons here
                const SizedBox(width: 16),
              ],
            ),
        ],
      ),
      body: navigationShell,
      // Conditionally add the footer only if the current index is 0 (Home screen)
    );
  }

  // Helper method for desktop/tablet buttons
  Widget _buildTextButton(BuildContext context, String label, IconData icon,
      int index, int currentIndex) {
    final bool isSelected = index == currentIndex;
    final Color color = isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface;
    return TextButton.icon(
      onPressed: () => _onTap(index),
      icon: Icon(icon, color: color),
      label: Text(
        label,
        style: TextStyle(color: color),
      ),
    );
  }

  // Helper method for mobile menu items
  PopupMenuItem<int> _buildPopupMenuItem(BuildContext context, String label,
      IconData icon, int index, int currentIndex) {
    final bool isSelected = index == currentIndex;
    return PopupMenuItem<int>(
      value: index,
      child: ListTile(
        leading: Icon(icon,
            color: isSelected ? Theme.of(context).colorScheme.primary : null),
        title: Text(label,
            style: TextStyle(
                color:
                    isSelected ? Theme.of(context).colorScheme.primary : null)),
      ),
    );
  }
}
