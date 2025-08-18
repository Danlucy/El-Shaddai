import 'package:flutter/material.dart';

class HoverBorderContainer extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final double borderWidth;
  final Color hoverColor;

  const HoverBorderContainer({
    super.key,
    required this.child,
    this.borderRadius = 12,
    this.borderWidth = 2,
    this.hoverColor = Colors.blue,
  });

  @override
  State<HoverBorderContainer> createState() => _HoverBorderContainerState();
}

class _HoverBorderContainerState extends State<HoverBorderContainer> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: _hovering ? widget.hoverColor : Colors.transparent,
            width: widget.borderWidth,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
