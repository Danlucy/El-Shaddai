import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'dart:io' show Platform;

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo/main_logo.png',
              height: 300,
              width: 300,
            ),
            const SizedBox(
              height: 20,
            ),
            const SignInButton(
              mode: 'Google',
            ),
            const Gap(20),
            if (Platform.isIOS)
              const SignInButton(
                mode: 'Apple',
              ),
          ],
        ),
      ),
    );
  }
}
