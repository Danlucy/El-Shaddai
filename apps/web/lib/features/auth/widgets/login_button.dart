import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/auth_controller.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({required this.mode, super.key});
  final String mode;

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  // void signInWithApple(BuildContext context, WidgetRef ref) {
  //   ref.read(authControllerProvider.notifier).signInWithApple(context);
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isGoogle = mode == 'Google';
    final width = MediaQuery.sizeOf(context).width;

    // Define styles based on the mode
    final ButtonStyle style = isGoogle
        ? ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          )
        : ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          );

    final Widget icon = isGoogle
        ? Image.asset(
            'assets/logo/google.png', // Make sure you have this asset
            height: 24,
            width: 24,
          )
        : Icon(Icons.apple, color: Theme.of(context).colorScheme.onPrimary);

    return FractionallySizedBox(
      widthFactor: 0.9,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 70, minHeight: 50),
        child: ElevatedButton.icon(
          onPressed: () {
            signInWithGoogle(context, ref);
            // isGoogle
            //     ? signInWithGoogle(context, ref)
            //     : signInWithApple(context, ref);
            Navigator.of(context).pop();
          },
          icon: icon,
          style: style,
          label: AutoSizeText(
            'Continue with $mode',
            maxLines: 1,
            minFontSize: 12,
            maxFontSize: 18,
          ),
        ),
      ),
    );
  }
}
