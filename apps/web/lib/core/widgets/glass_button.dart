import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:website/core/utility/utility.dart';

import '../constants.dart';

/// A reusable button with a glassmorphism effect.
///
/// This button can be customized with a specific text label, an icon,
/// and a callback function that is executed when the button is tapped.
class GlassmorphicButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final BoxConstraints? constraints;

  /// Custom border radius (defaults to 12 if not provided)
  final double borderRadius;

  /// Optional custom background colors for the blur
  final List<Color>? backgroundColors;

  const GlassmorphicButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.constraints,
    this.borderRadius = 12,
    this.backgroundColors,
  }) : super(key: key);

  @override
  State<GlassmorphicButton> createState() => _GlassmorphicButtonState();
}

class _GlassmorphicButtonState extends State<GlassmorphicButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = widget.backgroundColors ??
        [
          Colors.white.withOpacity(_isHovered ? 0.2 : 0.1),
          Colors.white.withOpacity(_isHovered ? 0.15 : 0.05),
        ];

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GlassmorphicContainer(
        constraints: widget.constraints,
        width: 300,
        height: 60,
        borderRadius: widget.borderRadius,
        blur: 10,
        alignment: Alignment.center,
        border: 2,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
          stops: const [0.1, 1],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(_isHovered ? 0.8 : 0.5),
            Colors.white.withOpacity(_isHovered ? 0.8 : 0.5),
          ],
        ),
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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

class DownloadButtons extends StatefulWidget {
  final double borderRadius; // 👈 new

  const DownloadButtons({
    Key? key,
    this.borderRadius = 30, // 👈 default
  }) : super(key: key);

  @override
  State<DownloadButtons> createState() => _DownloadButtonsState();
}

class _DownloadButtonsState extends State<DownloadButtons> {
  bool isHoveredGoogle = false;
  bool isHoveredApple = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GlassmorphicContainer(
        width: 350,
        height: 60,
        borderRadius: widget.borderRadius, // 👈 use param
        blur: 10,
        border: 1,
        alignment: Alignment.center,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpac(0.2),
            Colors.white.withOpac(0.1),
          ],
          stops: const [0.1, 1.0],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpac(0.5),
            Colors.white.withOpac(0.5),
          ],
        ),
        child: Row(
          children: [
            // Google Play side
            Expanded(
              child: MouseRegion(
                onEnter: (_) => setState(() => isHoveredGoogle = true),
                onExit: (_) => setState(() => isHoveredGoogle = false),
                child: InkWell(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(widget.borderRadius),
                    bottomLeft: Radius.circular(widget.borderRadius),
                  ), // 👈 use param
                  onTap: () => launchURL(googleAppURL),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: isHoveredGoogle
                          ? Colors.white.withOpac(0.05)
                          : Colors.transparent,
                      boxShadow: isHoveredGoogle
                          ? [
                              BoxShadow(
                                color: Colors.greenAccent.withOpac(0.5),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                          : [],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(widget.borderRadius),
                        bottomLeft: Radius.circular(widget.borderRadius),
                      ), // 👈 use param
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/logo/google_play.png', height: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'Google Play',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Divider
            Container(
              width: 1,
              color: Colors.white.withOpac(0.3),
              margin: const EdgeInsets.symmetric(vertical: 8),
            ),

            // App Store side
            Expanded(
              child: MouseRegion(
                onEnter: (_) => setState(() => isHoveredApple = true),
                onExit: (_) => setState(() => isHoveredApple = false),
                child: InkWell(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(widget.borderRadius),
                    bottomRight: Radius.circular(widget.borderRadius),
                  ), // 👈 use param
                  onTap: () => launchURL(appleAppURL),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: isHoveredApple
                          ? Colors.white.withOpac(0.05)
                          : Colors.transparent,
                      boxShadow: isHoveredApple
                          ? [
                              BoxShadow(
                                color: Colors.blueAccent.withOpac(0.5),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                          : [],
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(widget.borderRadius),
                        bottomRight: Radius.circular(widget.borderRadius),
                      ), // 👈 use param
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/logo/apple_store.png', height: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'App Store',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
