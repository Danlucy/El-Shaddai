import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({required this.date, required this.color, super.key});

  final DateTime date;
  static final monthFormat = DateFormat('MMM');
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: 80,
      height: 100,
      borderRadius: 12,
      blur: 10,
      border: 2,
      linearGradient: LinearGradient(
        colors: [Colors.white.withOpac(0.1), Colors.white.withOpac(0.05)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradient: LinearGradient(
        colors: [color.withOpac(0.5), color.withOpac(0.5)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Top section for the month
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: color.withOpac(0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  monthFormat.format(date).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Bottom section for the day
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                date.day.toString(),
                style: TextStyle(
                  fontSize: 28,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
