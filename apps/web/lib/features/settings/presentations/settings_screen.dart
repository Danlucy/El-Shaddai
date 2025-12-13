import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:website/core/widgets/animated_background.dart';
import 'package:website/core/widgets/organization_drop_down_button.dart';
import 'package:website/features/auth/controller/auth_controller.dart';
import 'package:website/features/auth/presentations/login_dialog.dart';

// Example providers

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final bool isLoggedIn = ref.read(userProvider.notifier).isLoggedIn;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: AnimatedBackground(
              surfaceColor: Theme.of(context).colorScheme.surface,
              secondaryColor: Theme.of(context).colorScheme.secondary,
              child: const SizedBox.expand(),
            ),
          ),

          // Content
          SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 800 : double.infinity,
                ),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Preferences",
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                            const Gap(16),

                            // 1. STANDARD TOGGLE EXAMPLE
                            SettingsTile(
                              title: "Select Prayer Alter",
                              subtitle:
                                  "Change the current Prayer Alter you are currently on.",
                              icon: Icons.notifications_active_outlined,
                              trailing: OrganizationSelectionDropdown(),
                            ),

                            const Gap(16),

                            // 4. CUSTOM WIDGET EXAMPLE (Navigation Arrow)
                            SettingsTile(
                              title: "Log In/Out",
                              subtitle: "Log in or out your gmail account",
                              icon: Icons.key,
                              // ✅ Custom Widget: Simple Icon Button
                              trailing: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: isLoggedIn
                                      ? context.colors.errorContainer.withOpac(
                                          0.3,
                                        )
                                      : null,
                                ),
                                child: Text(isLoggedIn ? 'Log Out' : "Log In"),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const GlassLoginDialog();
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A generic settings tile that acts as a Toggle by default,
/// but accepts a [trailing] widget to override that behavior.
class SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;

  // Toggle specific (Optional)
  final bool? value;
  final ValueChanged<bool>? onChanged;

  // Custom Override (Optional)
  final Widget? trailing;

  const SettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.value,
    this.onChanged,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 90,
      borderRadius: 16,
      blur: 15,
      border: 1,
      linearGradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.surface.withOpac(0.12),
          Theme.of(context).colorScheme.surface.withOpac(0.07),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradient: LinearGradient(
        colors: [
          Colors.white.withOpac(0.5),
          Colors.white.withOpac(0.3),
          Colors.white.withOpac(0.2),

          Colors.white.withOpac(0.1),
        ],
      ),
      child: Center(
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpac(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpac(0.6),
                  ),
                )
              : null,

          // ✅ LOGIC: If 'trailing' exists, use it.
          // Otherwise, if 'value' is provided, render the Switch.
          trailing:
              trailing ??
              (value != null
                  ? Switch.adaptive(
                      value: value!,
                      activeThumbColor: Theme.of(context).colorScheme.primary,
                      onChanged: onChanged,
                    )
                  : null),
        ),
      ),
    );
  }
}
