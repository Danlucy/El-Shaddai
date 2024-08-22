import 'dart:io';
import 'package:flutter/scheduler.dart';
import 'package:el_shaddai/core/router/router.dart';
import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/features/auth/controller/auth_controller.dart';
import 'package:el_shaddai/features/auth/repository/auth_repository.dart';
import 'package:el_shaddai/firebase_options.dart';
import 'package:el_shaddai/models/user_model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// AIzaSyB7yJR6X1DOKCmmHwH4wI0TXXhMAVxyV0g
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
    isOnline
        ? ProviderScope(
            child: MyApp(),
          )
        : const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Text(
                  'No Internet',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
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
  const _MyApp({super.key});

  @override
  ConsumerState<_MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<_MyApp> {
  @override
  Widget build(BuildContext context) {
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
