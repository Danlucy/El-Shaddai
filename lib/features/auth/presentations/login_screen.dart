import 'package:el_shaddai/features/auth/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
        title: const Text(
          'El Shaddai',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo/wings_of_freedom.png',
              height: 200,
            ),
            const SizedBox(
              height: 20,
            ),
            const SignInButton(
              mode: 'Google',
            ),
            Gap(20),
            const SignInButton(
              mode: 'Apple',
            ),
          ],
        ),
      ),
    );
  }
}
