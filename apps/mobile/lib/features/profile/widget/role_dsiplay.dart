import 'dart:ui';

import 'package:constants/constants.dart';
import 'package:flutter/material.dart';

import 'package:mobile/models/user_model/user_model.dart';

class RoleDisplayWidget extends StatelessWidget {
  final UserRole? role;
  final TextStyle? textStyle;

  const RoleDisplayWidget({
    super.key,
    required this.role,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    Color roleColor;
    switch (role) {
      case UserRole.admin:
        roleColor = Colors.red.shade300; // Lighter shade for contrast
        break;
      case UserRole.watchman:
        roleColor = Colors.orange.shade300;
        break;
      case UserRole.watchLeader:
        roleColor = Colors.blue.shade300;
        break;
      case UserRole.intercessor:
        roleColor = Colors.green.shade300;
        break;
      default:
        roleColor = Colors.grey.shade300;
    }

    return ClipRRect(
      borderRadius:
          BorderRadius.circular(10.0), // Rounded corners for the glass effect
      child: BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Adjust blur amount
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpac(0.15), // Semi-transparent white
            borderRadius: BorderRadius.circular(10.0),
            border:
                Border.all(color: Colors.white.withOpac(0.2)), // Subtle border
          ),
          child: Text(
            role?.displayName ?? 'Unknown Role',
            style:
                (textStyle ?? Theme.of(context).textTheme.titleSmall)?.copyWith(
              color: roleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
