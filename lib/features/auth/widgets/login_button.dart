import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton(
      {super.key,
      required this.text,
      required this.image,
      required this.onPressed,
      this.iconColor});

  final String text;
  final String image;
  final VoidCallback onPressed;
  final Color? iconColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Image.asset(
        image,
        height: 40,
        width: 40,
        color: iconColor,
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
      label: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
