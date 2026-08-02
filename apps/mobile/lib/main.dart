import 'dart:async';

import 'package:constants/constants.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/router/no_internet_screen.dart';
import 'package:mobile/core/router/router.dart';
import 'package:mobile/features/auth/controller/auth_controller.dart';
import 'package:mobile/features/booking/provider/booking_submission_provider.dart';
import 'package:mobile/features/settings/state/settings_state.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:util/util.dart';

import 'features/booking/state/booking_submission_state.dart';

final ValueNotifier<bool> hasConnectivity = ValueNotifier(true);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await SettingsState.instance.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _activateFirebaseAppCheck();
  await initializeGoogleSignIn();

  final isConnected = await Backend.checkInternetAccess();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  hasConnectivity.value = isConnected;

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

Future<void> _activateFirebaseAppCheck() async {
  if (kIsWeb ||
      (defaultTargetPlatform != TargetPlatform.android &&
          defaultTargetPlatform != TargetPlatform.iOS &&
          defaultTargetPlatform != TargetPlatform.macOS)) {
    return;
  }

  await FirebaseAppCheck.instance.activate(
    providerAndroid: kDebugMode
        ? const AndroidDebugProvider()
        : const AndroidPlayIntegrityProvider(),
    providerApple: kDebugMode
        ? const AppleDebugProvider()
        : const AppleDeviceCheckProvider(),
  );

  if (kDebugMode) {
    try {
      final token = await FirebaseAppCheck.instance.getToken(true);
      debugPrint(
        'App Check token refresh: present=${token != null}, '
        'jwtSegments=${token?.split('.').length}',
      );
    } catch (error) {
      debugPrint('App Check token refresh failed: $error');
    }
  }
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
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkConnectivityAndUpdateUser();
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground message received: ${message.notification?.title}');
      if (message.notification != null) {
        // You can show a local notification here if desired
        // Or update UI directly
      }
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
      final hasInternet = await Backend.checkInternetAccess();
      hasConnectivity.value = hasInternet;

      if (!hasInternet || !mounted) return;

      try {
        final userModel = await ref
            .read(authControllerProvider.notifier)
            .getUserDataStream()
            .first;

        if (mounted && userModel != null) {
          ref.read(userProvider.notifier).setUser(userModel);
        }
      } on FirebaseException catch (e) {
        if (kDebugMode) {
          print('Firebase Error updating user data: ${e.code} - ${e.message}');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Generic Error updating user data: $e');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Connectivity check error during user data update: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);
    ref.listen(bookingSubmissionNotifierProvider, (previous, next) {
      if (previous?.status == next.status &&
          previous?.request?.requestId == next.request?.requestId &&
          previous?.message == next.message) {
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final messenger = _scaffoldMessengerKey.currentState;
        if (messenger == null) return;

        messenger.clearSnackBars();
        switch (next.status) {
          case BookingSubmissionStatus.idle:
            break;
          case BookingSubmissionStatus.submitting:
            messenger.showSnackBar(
              const SnackBar(content: Text('Saving booking…')),
            );
            break;
          case BookingSubmissionStatus.success:
            messenger.showSnackBar(
              SnackBar(
                content: Text(next.message ?? 'Booking saved.'),
                backgroundColor: Colors.green,
              ),
            );
            break;
          case BookingSubmissionStatus.failure:
            messenger.showSnackBar(
              SnackBar(
                content: Text(
                  next.message ?? 'The booking could not be saved.',
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 12),
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () {
                    ref
                        .read(bookingSubmissionNotifierProvider.notifier)
                        .retry();
                  },
                ),
              ),
            );
            break;
        }
      });
    });

    return ShowCaseWidget(
      builder: (showcaseContext) {
        return MaterialApp.router(
          scaffoldMessengerKey: _scaffoldMessengerKey,
          title: 'El Shaddai',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: const AppBarTheme(titleSpacing: 0),
            textTheme: textTheme,
            useMaterial3: true,
            colorScheme: MaterialTheme.darkScheme(),
          ),
          darkTheme: ThemeData(
            appBarTheme: const AppBarTheme(titleSpacing: 0),
            textTheme: textTheme,
            useMaterial3: true,
            colorScheme: MaterialTheme.darkScheme(),
          ),
          routerConfig: router,
        );
      },
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Background message: ${message.notification?.title}');
}
