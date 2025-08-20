// lib/widgets/glass_list_tile.dart
// Requires: glassmorphism: ^3.0.0 (or your existing version)
// Drop this file anywhere in your project and import it.

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

/// A sleek iOS-style frosted ListTile using the `glassmorphism` package.
/// - Soft blur with subtle inner/outer border glows
/// - Rounded corners (defaults to iOS-like 18–20)
/// - Ink response w/ gentle scale on press
/// - Adapts to Light/Dark themes
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
        (isDark ? Colors.white : Colors.black).withOpacity(baseOpacity * 0.30),
        (isDark ? Colors.white : Colors.black).withOpacity(baseOpacity * 0.10),
      ],
    );

    final borderGrad = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(isDark ? 0.16 : 0.30),
        Colors.white.withOpacity(0.05),
      ],
    );

    final radius = BorderRadius.circular(widget.borderRadius);

    return AnimatedScale(
      scale: _pressed ? 0.985 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: GlassmorphicContainer(
        width: double.infinity,
        height: widget.height,
        borderRadius: widget.borderRadius,
        blur: widget.blur,
        border: 1.2,
        alignment: Alignment.centerLeft,
        linearGradient: gradient,
        borderGradient: borderGrad,
        child: _InkLayer(
          radius: radius,
          onTapDown: () => setState(() => _pressed = true),
          onTapUpOrCancel: () => setState(() => _pressed = false),
          onTap: widget.onTap,
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
                            color: Theme.of(context).colorScheme.onSurface
                                .withOpacity(isDark ? 0.95 : 0.90),
                          ),
                          child: widget.title!,
                        ),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: 3),
                        DefaultTextStyle.merge(
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.onSurface
                                .withOpacity(isDark ? 0.65 : 0.60),
                          ),
                          child: widget.subtitle!,
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.trailing != null) ...[
                  const SizedBox(width: 12),
                  widget.trailing!,
                ],
              ],
            ),
          ),
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
        splashColor: Colors.white.withOpacity(0.10),
        highlightColor: Colors.white.withOpacity(0.06),
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
        colors: [
          Colors.white.withOpacity(0.20),
          Colors.white.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.40),
          Colors.white.withOpacity(0.05),
        ],
      ),
      child: Center(child: child),
    );
  }
}

// ---------------- DEMO ----------------
// Example usage (put this in any screen to preview quickly):
//
// Scaffold(
//   backgroundColor: const Color(0xFF0F1115), // looks great behind glass
//   appBar: AppBar(title: const Text('Glass ListTiles')),
//   body: ListView.separated(
//     padding: const EdgeInsets.all(16),
//     itemCount: 8,
//     separatorBuilder: (_, __) => const SizedBox(height: 12),
//     itemBuilder: (context, i) {
//       return GlassListTile(
//         leading: Icon(Icons.person, size: 20, color: Colors.white.withOpacity(0.9)),
//         title: Text('Contact ${i + 1}'),
//         subtitle: const Text('Last seen recently'),
//         trailing: Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.7)),
//         onTap: () {},
//         selected: i == 1,
//       );
//     },
//   ),
// )
