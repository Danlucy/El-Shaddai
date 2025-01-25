import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/features/auth/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({
    super.key,
    required this.width,
    required this.height,
    required this.ref,
  });

  final double width;
  final double height;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width * 3 / 4,
        height: height * 1 / 4,
        decoration: BoxDecoration(
            color: context.colors.secondaryContainer,
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Confirm Log Out?',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            const SizedBox(
              height: 50,
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
                      'Cancel',
                      style: TextStyle(color: context.colors.onSurface),
                    )),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                  onPressed: () {
                    ref.read(authRepositoryProvider).logout();
                  },
                  child: Text(
                    'Confirm',
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
