import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({
    required this.date,
    required this.color,
    super.key,
  });

  final DateTime date;
  static final month = DateFormat('MMM');
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: IntrinsicHeight(
        child: AspectRatio(
          aspectRatio: 0.7, // Ensures the widget is a square
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: color),
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: color,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      month.format(date).toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
