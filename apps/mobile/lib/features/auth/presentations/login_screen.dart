import 'dart:io' show Platform;

import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mobile/core/widgets/organization_dropdown_button.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../widgets/login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.from});
  final String? from;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Align(
          alignment: AlignmentGeometry.center,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Gap(10),
                GradientText(
                  colors: [
                    context.colors.primary,
                    Colors.white70,
                    context.colors.secondary,
                  ],
                  'EL Shaddai 247 prayer altar for the Kingdom of God',
                  maxLines: 2,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                Image.asset(
                  'assets/logo/main_logo.png',
                  height: 300,
                  width: 300,
                ),
                const SizedBox(height: 20),
                Text(
                  'Select Prayer Alter',
                  style: TextStyle(
                    fontSize: 18,
                    color: context.colors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                OrganizationSelectionDropdown(),

                Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 20),
                  child: const SignInButton(mode: 'Google'),
                ),
                if (Platform.isIOS) const SignInButton(mode: 'Apple'),
                Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
