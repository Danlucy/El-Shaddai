import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:website/features/auth/controller/auth_controller.dart';
import 'package:website/features/auth/widgets/login_button.dart';

class GlassLoginDialog extends ConsumerStatefulWidget {
  const GlassLoginDialog({
    super.key,
    required this.onGoogleSignIn,
    required this.onAppleSignIn,
  });

  final VoidCallback onGoogleSignIn;
  final VoidCallback onAppleSignIn;

  @override
  ConsumerState<GlassLoginDialog> createState() => _GlassLoginDialogState();
}

class _GlassLoginDialogState extends ConsumerState<GlassLoginDialog> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: GlassmorphicContainer(
        width: 400,
        height: 250,
        borderRadius: 20,
        blur: 15,
        border: 2,
        linearGradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface.withOpacity(0.1),
            Theme.of(context).colorScheme.surface.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderGradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                // Change the title based on the login state
                user == null ? 'Sign In' : 'You are signed in',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              // Conditionally show the correct buttons
              if (user == null) ...[
                // If user is null (logged out), show sign-in buttons
                const SignInButton(mode: 'Google'),
              ] else ...[
                // If user is not null (logged in), show a logout button
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(authControllerProvider.notifier).signOut();
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
