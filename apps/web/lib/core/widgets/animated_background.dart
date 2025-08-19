import 'package:constants/constants.dart';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final Color surfaceColor;
  final Color secondaryColor;

  const AnimatedBackground({
    super.key,
    required this.child,
    required this.surfaceColor,
    required this.secondaryColor,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _patternController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _patternAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _patternController = AnimationController(
      duration: const Duration(milliseconds: 30000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _patternAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _patternController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _patternController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _patternController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 2.0,
            colors: [
              widget.surfaceColor.withOpac(0.7),
              widget.surfaceColor,
              widget.surfaceColor.withOpac(0.9),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.transparent,
                widget.secondaryColor.withOpac(0.03),
                Colors.transparent,
                widget.secondaryColor.withOpac(0.05),
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: CustomPaint(
            painter: BackgroundPatternPainter(
              color: widget.secondaryColor.withOpac(0.08),
              animationValue: _patternAnimation,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

// Custom painter for animated diamond pattern (no changes needed here)
class BackgroundPatternPainter extends CustomPainter {
  final Color color;
  final Animation<double> animationValue;

  BackgroundPatternPainter({
    required this.color,
    required this.animationValue,
  }) : super(repaint: animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    const double spacing = 60.0;
    const double dotSize = 1.5;

    final double diagonalLength = size.width + size.height;
    final double sweepPosition = animationValue.value * diagonalLength;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        final double distanceFromTopRight = (size.width - x) + y;
        final double fadeRange = 200.0;
        double opacity = 0.0;

        if (distanceFromTopRight >= sweepPosition - fadeRange &&
            distanceFromTopRight <= sweepPosition + fadeRange) {
          final double distanceFromSweep =
              (distanceFromTopRight - sweepPosition).abs();
          opacity = 1.0 - (distanceFromSweep / fadeRange);
          opacity = opacity.clamp(0.0, 1.0);
        }

        if (opacity > 0.0) {
          final Paint fadedPaint = Paint()
            ..color = color.withOpacity(color.opacity * opacity)
            ..style = PaintingStyle.fill;

          final Path diamond = Path();
          diamond.moveTo(x, y - 8);
          diamond.lineTo(x + 8, y);
          diamond.lineTo(x, y + 8);
          diamond.lineTo(x - 8, y);
          diamond.close();

          canvas.drawPath(diamond, fadedPaint);

          canvas.drawCircle(
            Offset(x, y),
            dotSize,
            fadedPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
