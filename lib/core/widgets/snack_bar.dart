import 'package:flutter/material.dart';

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

void showSuccessfulSnackBar(BuildContext context, String text) {
  print(text);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
}
