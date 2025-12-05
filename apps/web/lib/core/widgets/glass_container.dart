import 'dart:ui';

import 'package:constants/constants.dart';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final BorderRadiusGeometry? borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double blur;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GlassContainer({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius,
    this.backgroundColor = const Color.fromARGB(255, 255, 255, 255),
    this.borderColor = const Color.fromARGB(255, 255, 255, 255),
    this.borderWidth = 1.0,
    this.blur = 10.0,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(20.0),
        // Step 1: BackdropFilter provides the blur effect.
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            // Step 2: Use a semi-transparent background color.
            decoration: BoxDecoration(
              color: backgroundColor.withOpac(0.1),
              borderRadius: borderRadius ?? BorderRadius.circular(20.0),
              // Step 3: Add a subtle border to mimic a glass edge.
              border: Border.all(
                color: borderColor.withOpac(0.3),
                width: borderWidth,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
