import 'package:flutter/material.dart';

class Failure {
  final String message;

  Failure(this.message);
}

void showFailureSnackBar(BuildContext context, String text,
    {GlobalKey<ScaffoldMessengerState>? key}) {
  print(text);

  // Clear any existing snackbars first
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.redAccent,
      // 1. Make it float so it looks like a notification
      behavior: SnackBarBehavior.floating,
      // 2. Set duration to 20 seconds
      duration: const Duration(seconds: 20),
      // 3. Enable the native "X" button
      showCloseIcon: true,
      closeIconColor: Colors.white,

      content: Text(
        text,
        style: const TextStyle(fontSize: 13, color: Colors.white),
      ),
    ),
  );
}

class ErrorText extends StatelessWidget {
  const ErrorText({super.key, required this.error});
  final String error;
  @override
  Widget build(BuildContext context) {
    showFailureSnackBar(context, error);
    return Center(
      child: Text(error, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
