import 'dart:ui';

import 'package:api/api.dart';
import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:util/util.dart';
import 'package:website/core/widgets/animated_background.dart';
import 'package:website/core/widgets/organization_drop_down_button.dart';
import 'package:website/features/auth/controller/auth_controller.dart';
import 'package:website/features/auth/presentations/login_dialog.dart';
import 'package:website/features/auth/services/zoom_oauth_service.dart';

// Example providers

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isZoomAuthenticating = false;

  Future<void> _signInToZoom() async {
    if (_isZoomAuthenticating) return;

    setState(() => _isZoomAuthenticating = true);
    try {
      final accessToken = await ZoomOAuthService().signIn();
      await ref
          .read(accessTokenNotifierProvider.notifier)
          .saveAccessToken(accessToken);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signed in to Zoom successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showFailureSnackBar(context, e.toString());
    } finally {
      if (mounted) {
        setState(() => _isZoomAuthenticating = false);
      }
    }
  }

  Future<void> _signOutOfZoom() async {
    try {
      await ref
          .read(accessTokenNotifierProvider.notifier)
          .clearAccessToken();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signed out of Zoom successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showFailureSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    // FIX: Use ref.watch(userProvider) instead of ref.read(...)
    // This ensures the widget rebuilds immediately when login state changes.
    final user = ref.watch(userProvider).value; // This gives you User? directly
    final bool isLoggedIn = null != user;
    final zoomAccessToken = ref.watch(accessTokenNotifierProvider);
    final isZoomSignedIn = zoomAccessToken.value != null;
    final isZoomBusy = zoomAccessToken.isLoading || _isZoomAuthenticating;
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
          Positioned.fill(
            child: AnimatedBackground(
              surfaceColor: Theme.of(context).colorScheme.surface,
              secondaryColor: Theme.of(context).colorScheme.secondary,
              child: const SizedBox.expand(),
            ),
          ),
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
                            SettingsTile(
                              title: "Select Prayer Alter",
                              subtitle:
                                  "Change the current Prayer Alter you are currently on.",
                              icon: Icons.notifications_active_outlined,
                              trailing: OrganizationSelectionDropdown(),
                            ),
                            const Gap(16),

                            SettingsTile(
                              title: "Zoom",
                              subtitle: isZoomSignedIn
                                  ? "Automatic Zoom meeting creation is enabled."
                                  : "Sign in to enable automatic Zoom meeting creation.",
                              leading: Container(
                                width: 44,
                                height: 44,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: context.colors.primary.withOpac(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  'assets/zoom.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              trailing: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: isZoomSignedIn
                                      ? context.colors.errorContainer.withOpac(
                                          0.3,
                                        )
                                      : null,
                                  side: BorderSide(
                                    color: isZoomSignedIn
                                        ? context.colors.error
                                        : context.colors.primary,
                                  ),
                                ),
                                onPressed: isZoomBusy
                                    ? null
                                    : () async {
                                        if (isZoomSignedIn) {
                                          await _signOutOfZoom();
                                        } else {
                                          await _signInToZoom();
                                        }
                                      },
                                child: isZoomBusy
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        isZoomSignedIn ? 'Log Out' : 'Sign In',
                                        style: TextStyle(
                                          color: isZoomSignedIn
                                              ? context.colors.error
                                              : context.colors.primary,
                                        ),
                                      ),
                              ),
                            ),
                            const Gap(16),

                            // Log In/Out Tile
                            SettingsTile(
                              title: "Log In/Out",
                              subtitle: "Log in or out your gmail account",
                              icon: Icons.key,
                              trailing: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: isLoggedIn
                                      ? Theme.of(context)
                                            .colorScheme
                                            .errorContainer
                                            .withOpac(0.3)
                                      : null,
                                  side: BorderSide(
                                    color: isLoggedIn
                                        ? Theme.of(context).colorScheme.error
                                        : Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const GlassLoginDialog(),
                                  );
                                },
                                child: Text(
                                  isLoggedIn ? 'Log Out' : "Log In",
                                  style: TextStyle(
                                    color: isLoggedIn
                                        ? Theme.of(context).colorScheme.error
                                        : Theme.of(context).colorScheme.primary,
                                  ),
                                ),
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
/// but accepts [leading] and [trailing] widgets to override that behavior.

class SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? leading;

  // Toggle specific
  final bool? value;
  final ValueChanged<bool>? onChanged;

  // Custom Override
  final Widget? trailing;

  const SettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.leading,
    this.value,
    this.onChanged,
    this.trailing,
  }) : assert(icon != null || leading != null);

  @override
  Widget build(BuildContext context) {
    // 1. Use ClipRRect + BackdropFilter to create the glass effect
    // This allows the container to grow dynamically with content (unlike GlassmorphicContainer)
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          // 2. Replicate the gradient styles from your original code
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpac(
                0.3,
              ), // Approx average of your border gradient
              width: 1,
            ),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.surface.withOpac(0.12),
                Theme.of(context).colorScheme.surface.withOpac(0.07),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            // 3. Add vertical padding so multi-line text doesn't touch the edges
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ListTile(
              leading:
                  leading ??
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpac(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: subtitle != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        subtitle!,
                        // 4. Remove 'maxLines' and 'overflow' to allow wrapping
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpac(0.6),
                        ),
                      ),
                    )
                  : null,
              trailing:
                  trailing ??
                  (value != null
                      ? Switch.adaptive(
                          value: value!,
                          activeThumbColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          onChanged: onChanged,
                        )
                      : null),
            ),
          ),
        ),
      ),
    );
  }
}
