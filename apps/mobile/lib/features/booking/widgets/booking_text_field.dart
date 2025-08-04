import 'package:flutter/material.dart';

class BookingTextField extends StatelessWidget {
  final String? initialValue;
  final String label;
  final String validationMessage;
  final void Function(String)? onChanged;
  final int maxLines;

  const BookingTextField({
    super.key,
    required this.label,
    required this.validationMessage,
    this.initialValue,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => (value?.isEmpty ?? true) ? validationMessage : null,
      onChanged: onChanged,
      maxLines: maxLines,
      decoration: InputDecoration(
        label: Text(label),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
