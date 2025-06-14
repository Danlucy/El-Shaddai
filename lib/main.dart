import 'dart:async';
import 'dart:io';

import 'package:el_shaddai/core/router/no_internet_screen.dart';
import 'package:el_shaddai/core/router/router.dart';
import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/core/utility/backend_checker.dart';
import 'package:el_shaddai/features/auth/controller/auth_controller.dart';
import 'package:el_shaddai/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Check both basic internet and Firebase connectivity
  bool hasConnectivity = await BackendChecker.checkConnectivity();

  runApp(
    hasConnectivity
        ? const ProviderScope(child: MyApp())
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
    return const ProviderScope(child: _MyApp());
  }
}

class _MyApp extends ConsumerStatefulWidget {
  const _MyApp();

  @override
  ConsumerState<_MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<_MyApp> with WidgetsBindingObserver {
  Timer? _connectivityTimer;

  Future<void> _checkConnectivityAndUpdateUser() async {
    try {
      final hasConnection = await BackendChecker.checkConnectivity();

      if (hasConnection && mounted) {
        print('Connected - updating user data');
        ref
            .read(authControllerProvider.notifier)
            .getUserDataStream()
            .first
            .then((userModel) {
          if (mounted) {
            ref.read(userProvider.notifier).update((state) => userModel);
          }
        }).catchError((error) {
          print('Error updating user data: $error');
        });
      }
    } catch (e) {
      print('Connectivity check error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initial check after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkConnectivityAndUpdateUser();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // Debounce connectivity checks when app resumes
      _connectivityTimer?.cancel();
      _connectivityTimer = Timer(const Duration(milliseconds: 500), () {
        if (mounted) {
          _checkConnectivityAndUpdateUser();
        }
      });
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _connectivityTimer?.cancel();
    }
  }

  @override
  void dispose() {
    _connectivityTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'El Shaddai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(titleSpacing: 0),
          textTheme: textTheme,
          useMaterial3: true,
          colorScheme: MaterialTheme.darkScheme()),
      darkTheme: ThemeData(
          appBarTheme: const AppBarTheme(titleSpacing: 0),
          textTheme: textTheme,
          useMaterial3: true,
          colorScheme: MaterialTheme.darkScheme()),
      routerConfig: router,
    );
  }
}
