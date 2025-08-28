import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class GlassListTile extends StatefulWidget {
  const GlassListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.height = 72,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    this.blur = 16,
    this.tintOpacity = 0.18,
    this.isToggle = false,
    this.toggleValue = false,
    this.onToggleChanged,
    this.borderTitle, // New parameter for border title
    this.borderTitleStyle, // Optional custom style for border title
  });

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool selected;
  final double height;
  final double borderRadius;
  final EdgeInsets padding;
  final double blur;

  /// How strong the frosted tint looks (0–1)
  final double tintOpacity;

  /// Whether this tile should display a toggle switch
  final bool isToggle;

  /// The current value of the toggle switch
  final bool toggleValue;

  /// Callback when toggle value changes
  final ValueChanged<bool>? onToggleChanged;

  /// Small title that appears at the top-left border
  final String? borderTitle;

  /// Custom style for the border title
  final TextStyle? borderTitleStyle;

  @override
  State<GlassListTile> createState() => _GlassListTileState();
}

class _GlassListTileState extends State<GlassListTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Base surface tint (slightly stronger when selected)
    final double baseOpacity = (widget.selected ? 0.22 : widget.tintOpacity)
        .clamp(0.0, 0.45);

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        (isDark ? Colors.white : Colors.black).withOpac(baseOpacity * 0.30),
        (isDark ? Colors.white : Colors.black).withOpac(baseOpacity * 0.10),
      ],
    );

    final borderGrad = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpac(isDark ? 0.16 : 0.30),
        Colors.white.withOpac(0.05),
      ],
    );

    final radius = BorderRadius.circular(widget.borderRadius);

    // If no border title, use the original layout
    if (widget.borderTitle == null) {
      return AnimatedScale(
        scale: _pressed ? 0.985 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: GlassmorphicContainer(
          margin: EdgeInsetsGeometry.all(6),
          width: double.infinity,
          height: widget.height,
          borderRadius: widget.borderRadius,
          blur: widget.blur,
          border: 1.2,
          alignment: Alignment.centerLeft,
          linearGradient: gradient,
          borderGradient: borderGrad,
          child: _buildContent(radius),
        ),
      );
    }

    // With border title layout
    return AnimatedScale(
      scale: _pressed ? 0.985 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Container(
        margin: const EdgeInsets.only(top: 10), // Space for border title
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main glass container
            GlassmorphicContainer(
              margin: EdgeInsetsGeometry.all(6),
              width: double.infinity,
              height: widget.height,
              borderRadius: widget.borderRadius,
              blur: widget.blur,
              border: 1.2,
              alignment: Alignment.centerLeft,
              linearGradient: gradient,
              borderGradient: borderGrad,
              child: _buildContent(radius),
            ),

            // Border title - perfectly positioned using intrinsic measurements
            Positioned(
              left: 20,
              top: -3,
              child: IntrinsicWidth(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withOpac(isDark ? 0.15 : 0.25),
                      width: 0.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpac(0.08),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.borderTitle!,
                    style:
                        widget.borderTitleStyle ??
                        TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface
                              .withOpac(isDark ? 0.75 : 0.70),
                          height: 1.2,
                          letterSpacing: 0.3,
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

  Widget _buildContent(BorderRadius radius) {
    return _InkLayer(
      radius: radius,
      onTapDown: () => setState(() => _pressed = true),
      onTapUpOrCancel: () => setState(() => _pressed = false),
      onTap: widget.isToggle
          ? () => widget.onToggleChanged?.call(!widget.toggleValue)
          : widget.onTap,
      onLongPress: widget.onLongPress,
      child: Padding(
        padding: widget.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.leading != null) ...[
              _AvatarGlassWrap(child: widget.leading!),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.title != null)
                    DefaultTextStyle.merge(
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: widget.selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface.withOpac(
                          Theme.of(context).brightness == Brightness.dark
                              ? 0.95
                              : 0.90,
                        ),
                      ),
                      child: widget.title!,
                    ),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 3),
                    DefaultTextStyle.merge(
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurface.withOpac(
                          Theme.of(context).brightness == Brightness.dark
                              ? 0.65
                              : 0.60,
                        ),
                      ),
                      child: widget.subtitle!,
                    ),
                  ],
                ],
              ),
            ),
            if (widget.isToggle) ...[
              const SizedBox(width: 12),
              _GlassToggleSwitch(
                value: widget.toggleValue,
                onChanged: widget.onToggleChanged,
              ),
            ] else if (widget.trailing != null) ...[
              const SizedBox(width: 12),
              widget.trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Custom glass-style toggle switch with smooth animations
class _GlassToggleSwitch extends StatelessWidget {
  const _GlassToggleSwitch({required this.value, this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 50,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: value
                ? [
                    context.colors.primaryContainer.withOpac(0.8),
                    context.colors.primaryContainer.withOpac(0.9),
                  ]
                : [
                    (isDark ? Colors.white : Colors.black).withOpac(0.15),
                    (isDark ? Colors.white : Colors.black).withOpac(0.05),
                  ],
          ),
          border: Border.all(
            color: value
                ? context.colors.primaryContainer.withOpac(0.3)
                : Colors.white.withOpac(isDark ? 0.2 : 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: value
                  ? context.colors.primaryContainer.withOpac(0.2)
                  : Colors.black.withOpac(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background blur effect
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withOpac(0.05)),
              ),
            ),
            // Toggle knob
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(2),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      context.colors.onSurface.withOpac(0.95),
                      context.colors.onSurface.withOpac(0.8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpac(0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                    BoxShadow(
                      color: context.colors.onSurface.withOpac(0.3),
                      blurRadius: 2,
                      offset: const Offset(0, -0.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Transparent Ink + gestures while preserving the glass look.
class _InkLayer extends StatelessWidget {
  const _InkLayer({
    required this.child,
    required this.radius,
    this.onTap,
    this.onLongPress,
    required this.onTapDown,
    required this.onTapUpOrCancel,
  });

  final Widget child;
  final BorderRadius radius;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback onTapDown;
  final VoidCallback onTapUpOrCancel;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: radius,
        splashColor: Colors.white.withOpac(0.10),
        highlightColor: Colors.white.withOpac(0.06),
        onTap: onTap,
        onLongPress: onLongPress,
        onTapDown: (_) => onTapDown(),
        onTapCancel: onTapUpOrCancel,
        onTapUp: (_) => onTapUpOrCancel(),
        child: child,
      ),
    );
  }
}

/// Small glass capsule for typical leading avatars/icons to match iOS feel.
class _AvatarGlassWrap extends StatelessWidget {
  const _AvatarGlassWrap({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: 40,
      height: 40,
      borderRadius: 12,
      blur: 12,
      border: 1,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white.withOpac(0.20), Colors.white.withOpac(0.05)],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white.withOpac(0.40), Colors.white.withOpac(0.05)],
      ),
      child: Center(child: child),
    );
  }
}
