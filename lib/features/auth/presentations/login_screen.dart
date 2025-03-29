import 'package:el_shaddai/features/auth/controller/auth_controller.dart';
import 'package:el_shaddai/features/auth/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.from});
  final String? from;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  void signInWithApple(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithApple(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
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
              SignInButton(
                text: 'Continue with Google',
                image: 'assets/logo/google.png',
                onPressed: () => signInWithGoogle(context, ref),
              ),
              const Gap(16),
              SignInButton(
                text: 'Continue with Apple',
                image: 'assets/logo/apple.png',
                onPressed: () => signInWithApple(context, ref),
                iconColor: Theme.of(context).colorScheme.onSurface,
              ),
            ],
          ),
        ),
      );
    });
  }
}
