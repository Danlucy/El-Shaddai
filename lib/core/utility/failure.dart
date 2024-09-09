import 'package:el_shaddai/core/widgets/snack_bar.dart';
import 'package:flutter/material.dart';

class Failure {
  final String message;

  Failure(this.message);
}

class ErrorText extends StatelessWidget {
  const ErrorText({super.key, required this.error});
  final String error;
  @override
  Widget build(BuildContext context) {
    showFailureSnackBar(context, error);
    return Center(
      child: Text(error),
    );
  }
}
