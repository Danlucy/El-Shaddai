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
    return Center(
      child: Text(error),
    );
  }
}
