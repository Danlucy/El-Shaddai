import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

class DateHeaderWidget extends StatelessWidget {
  const DateHeaderWidget({super.key, required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    // 1. Calculate formatting locally within this widget
    final dayOfWeek = DateFormat('EEE').format(selectedDate);
    final dayOfMonth = DateFormat('d').format(selectedDate);
    final monthOfMonth = DateFormat('MMMM ').format(selectedDate);
    final yearOfMonth = DateFormat('yyyy').format(selectedDate);

    // 2. Calculate Responsive Text Size locally
    final bool isLargeText = ResponsiveValue(
      context,
      defaultValue: false,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: false),
        Condition.between(start: 450, end: 800, value: true),
        Condition.largerThan(name: TABLET, value: true),
      ],
    ).value;

    return SizedBox(
      width: double.infinity,
      child: GlassmorphicContainer(
        height: 60,
        width: double.infinity,
        border: 1,
        blur: 5,
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colors.secondary.withOpac(0.1),
            context.colors.primary.withOpac(0.1),
          ],
        ),
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colors.secondary.withOpac(0.1),
            context.colors.primary.withOpac(0.1),
          ],
        ),
        borderRadius: 12,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: '$dayOfWeek, '.toUpperCase(),
                  style: TextStyle(
                    fontSize: isLargeText ? 24 : 20,
                    fontWeight: FontWeight.normal,
                    color: context.colors.secondary.withOpac(0.8),
                  ),
                ),
                TextSpan(
                  text: '$dayOfMonth ',
                  style: TextStyle(
                    fontSize: isLargeText ? 28 : 26,
                    fontWeight: FontWeight.bold,
                    color: context.colors.secondary,
                  ),
                ),
                TextSpan(
                  text: monthOfMonth,
                  style: TextStyle(
                    fontSize: isLargeText ? 26 : 22,
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary.withOpac(0.8),
                  ),
                ),
                TextSpan(
                  text: yearOfMonth,
                  style: TextStyle(
                    fontSize: isLargeText ? 22 : 18,
                    fontWeight: FontWeight.normal,
                    color: context.colors.secondary.withOpac(0.8),
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
