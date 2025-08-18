import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// This conditional import is best practice for web-only libraries.
import 'package:web/web.dart' as web;

/// A utility function to open a given path in a new browser tab.
///
/// The path should be the full path including the hash,
/// e.g., '/#/booking/123'.
void openInNewTab(String path) {
  // kIsWeb is a constant that is true when the app is compiled for the web.
  if (kIsWeb) {
    web.window.open(path, '_blank');
  }
}

/// A wrapper widget that adds a right-click context menu to its child,
/// providing an "Open in new tab" option.
class NewTabContextMenu extends StatefulWidget {
  const NewTabContextMenu({
    super.key,
    required this.child,
    required this.url,
  });

  /// The widget that will have the context menu.
  final Widget child;

  /// The URL path to open in the new tab (e.g., '/#/booking/123').
  final String url;

  @override
  State<NewTabContextMenu> createState() => _NewTabContextMenuState();
}

class _NewTabContextMenuState extends State<NewTabContextMenu> {
  Offset _tapPosition = Offset.zero;

  void _showContextMenu(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 30, 30),
        Rect.fromLTWH(0, 0, overlay.size.width, overlay.size.height),
      ),
      items: [
        PopupMenuItem<void>(
          onTap: () => openInNewTab(widget.url),
          child: const ListTile(
            leading: Icon(Icons.open_in_new),
            title: Text('Open in new tab'),
          ),
        ),
      ],
    );
  }

  void _storeTapPosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: _storeTapPosition,
      onSecondaryTap: () => _showContextMenu(context),
      child: widget.child,
    );
  }
}

// --- EXAMPLE USAGE ---
//
// To use this, wrap any widget you want to be right-clickable.
// For example, in your DailyBookingDialog's appointmentBuilder:
//
// return NewTabContextMenu(
//   url: '/#/booking/${appointment.id}',
//   child: GestureDetector(
//     onTap: () {
//       context.pop();
//       context.go(
//         '/booking/${appointment.id}',
//         extra: appointment,
//       );
//     },
//     child: Container(
//       // Your existing appointment container...
//     ),
//   ),
// );
