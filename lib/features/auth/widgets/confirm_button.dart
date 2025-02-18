import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/features/auth/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({
    super.key,
    required this.confirmText,
    required this.cancelText,
    required this.description,
    required this.confirmAction,
  });

  final String confirmText;
  final String description;
  final String cancelText;
  final Function() confirmAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        width: 300 * 8 / 9,
        height: 600 * 1 / 3,
        decoration: BoxDecoration(
            color: context.colors.secondaryContainer,
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                description,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.onSurfaceVariant),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      cancelText,
                      style: TextStyle(color: context.colors.onSurface),
                    )),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                  onPressed: confirmAction,
                  child: Text(
                    confirmText,
                    style: TextStyle(color: context.colors.onSurface),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
