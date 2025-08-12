import 'package:flutter/material.dart';

void showSuccessfulSnackBar(BuildContext context, String text) {
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
