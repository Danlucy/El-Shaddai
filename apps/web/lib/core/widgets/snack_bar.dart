import 'package:constants/constants.dart';
import 'package:flutter/material.dart';

void showSuccessfulSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: context.colors.primaryContainer,
        content: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
}
