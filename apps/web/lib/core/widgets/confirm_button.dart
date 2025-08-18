import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.description,
    required this.confirmText,
    required this.cancelText,
    required this.confirmAction,
  });

  final String title;
  final String description;
  final String confirmText;
  final String cancelText;
  final Function() confirmAction;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: GlassmorphicContainer(
        width: 400,
        height: 220,
        borderRadius: 20,
        blur: 20,
        border: 2,
        linearGradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface.withOpac(0.3),
            Theme.of(context).colorScheme.surface.withOpac(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderGradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.onSurface.withOpac(0.4),
            Theme.of(context).colorScheme.onSurface.withOpac(0.8),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(cancelText),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.errorContainer,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: confirmAction,
                    child: Text(confirmText),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
