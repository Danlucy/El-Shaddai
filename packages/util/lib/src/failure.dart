import 'package:flutter/material.dart';

class Failure {
  final String message;

  Failure(this.message);
}

void showFailureSnackBar(BuildContext context, String text,
    {GlobalKey<ScaffoldMessengerState>? key}) {
  print(text);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          text,
          style: const TextStyle(fontSize: 13),
        ),
        duration: const Duration(seconds: 1),
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
