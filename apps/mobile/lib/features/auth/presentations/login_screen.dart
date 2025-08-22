import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mobile/core/widgets/organization_dropdown_button.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'EL Shaddai Prayer Altar',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
      ),
      body: Align(
        alignment: AlignmentGeometry.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset('assets/logo/main_logo.png', height: 300, width: 300),
            const SizedBox(height: 20),
            const SignInButton(mode: 'Google'),
            const Gap(20),
            if (Platform.isIOS) const SignInButton(mode: 'Apple'),
            Gap(20),
            OrganizationSelectionDropdown(),
          ],
        ),
      ),
    );
  }
}
