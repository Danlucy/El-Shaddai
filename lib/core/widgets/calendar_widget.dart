import 'package:el_shaddai/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalenderWidget extends StatelessWidget {
  const CalenderWidget({
    required this.date,
    super.key,
    required this.color,
  });
  final DateTime date;
  static final month = DateFormat('MMM');
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 45,
          height: 17,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: color, width: 2),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Center(
            child: Text(
              month.format(date).toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                color: context.colors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          width: 45,
          height: 28,
          decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(8)),
          ),
          child: Center(
            child: Text(
              date.day.toString(),
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
