import 'dart:async';
import 'dart:ui';

import 'package:constants/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/router/no_internet_screen.dart';
import 'package:mobile/core/router/router.dart';
import 'package:mobile/features/auth/controller/auth_controller.dart';
import 'package:mobile/firebase_options.dart';

import 'core/utility/backend_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final ValueNotifier<bool> hasConnectivity =
      ValueNotifier<bool>(await Backend.checkConnectivity());

  Timer.periodic(const Duration(seconds: 5), (timer) async {
    final connectivity = await Backend.checkConnectivity();
    if (hasConnectivity.value != connectivity) {
      hasConnectivity.value = connectivity;
    }
  });

  runApp(
    ValueListenableBuilder<bool>(
      valueListenable: hasConnectivity,
      builder: (context, isConnected, child) {
        return isConnected
            ? const ProviderScope(child: MobileApp())
            : const NoInternetScreen();
      },
    ),
  );
}

class MobileApp extends StatelessWidget {
  const MobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return const ProviderScope(child: _MyMobileApp());
  }
}

class _MyMobileApp extends ConsumerStatefulWidget {
  const _MyMobileApp();

  @override
  ConsumerState<_MyMobileApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<_MyMobileApp>
    with WidgetsBindingObserver {
  Timer? _connectivityTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkConnectivityAndUpdateUser();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
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

  void _checkConnectivityAndUpdateUser() async {
    try {
      final hasConnection = await Backend.checkConnectivity();
      if (hasConnection && mounted) {
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
