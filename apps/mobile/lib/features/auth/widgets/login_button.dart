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

  void signInWithApple(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithApple(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isGoogle = mode == 'Google';
    final width = MediaQuery.sizeOf(context).width;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: width * 0.9,
        minWidth: width * 0.4,
        maxHeight: 70,
        minHeight: 50,
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          isGoogle
              ? signInWithGoogle(context, ref)
              : signInWithApple(context, ref); //Add apple heere
        },
        icon: isGoogle
            ? Image.asset(
                'assets/logo/google.png',
                height: 40,
                width: 40,
              )
            : Padding(
                padding: EdgeInsets.all(5),
                child: Image.asset(
                  'assets/logo/apple.png',
                  height: 40,
                  width: 40,
                  color: Colors.white,
                ),
              ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
        label: AutoSizeText(
          maxLines: 1,
          minFontSize: 12,
          maxFontSize: 18,
          'Continue with $mode',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
