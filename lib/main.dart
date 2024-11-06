import 'dart:io';
import 'package:el_shaddai/core/router/no_internet_screen.dart';
import 'package:el_shaddai/core/router/router.dart';
import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/features/auth/controller/auth_controller.dart';
import 'package:el_shaddai/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  bool isOnline = await hasNetwork();
  runApp(
    (isOnline)
        ? const ProviderScope(
            child: MyApp(),
          )
        : const NoInternetScreen(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return const ProviderScope(
      child: _MyApp(),
    );
  }
}

class _MyApp extends ConsumerStatefulWidget {
  const _MyApp();

  @override
  ConsumerState<_MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<_MyApp> {
  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(authStateChangeProvider).value;
    if (userData != null) {
      ref
          .read(authControllerProvider.notifier)
          .getUserData(userData.uid)
          .first
          .then((userModel) {
        ref.read(userProvider.notifier).update((state) => userModel);
      });
    }
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'El Shaddai',
      theme: ThemeData(
          textTheme: textTheme,
          useMaterial3: true,
          colorScheme: MaterialTheme.darkScheme()),
      darkTheme: ThemeData(
          textTheme: textTheme,
          useMaterial3: true,
          colorScheme: MaterialTheme.darkScheme()),
      routerConfig: router,
    );
  }
}
