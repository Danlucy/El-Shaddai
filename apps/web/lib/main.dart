import 'dart:async'; // Added by user's main.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:constants/constants.dart'; // Added by user's main.dart
import 'package:firebase/firebase.dart'; // Added by user's main.dart
import 'package:firebase_core/firebase_core.dart'; // Added by user's main.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added by user's main.dart
import 'package:responsive_framework/responsive_framework.dart';
import 'package:util/util.dart'; // Added by user's main.dart

import 'core/router/router.dart'; // Added by user's main.dart
import 'features/auth/controller/auth_controller.dart'; // Added by user's main.dart

final ValueNotifier<bool> hasConnectivity = ValueNotifier(true);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final isConnected = await Backend.checkFirebaseAvailability();
  hasConnectivity.value = isConnected;

  runApp(
    ValueListenableBuilder<bool>(
      valueListenable: hasConnectivity,
      builder: (context, isConnected, child) {
        return isConnected
            ? const ProviderScope(child: WebApp())
            : ConnectivityErrorScreen(); // Enhanced error screen
      },
    ),
  );
}

// Enhanced connectivity error screen with retry functionality
class ConnectivityErrorScreen extends StatefulWidget {
  const ConnectivityErrorScreen({super.key});

  @override
  State<ConnectivityErrorScreen> createState() =>
      _ConnectivityErrorScreenState();
}

class _ConnectivityErrorScreenState extends State<ConnectivityErrorScreen> {
  bool _isRetrying = false;
  Timer? _autoRetryTimer;
  int _retryCount = 0;

  @override
  void initState() {
    super.initState();
    _startAutoRetry();
  }

  void _startAutoRetry() {
    _autoRetryTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_retryCount < 5) {
        // Limit auto-retries
        _checkConnectivity();
        _retryCount++;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _checkConnectivity() async {
    if (_isRetrying) return;

    setState(() {
      _isRetrying = true;
    });

    try {
      final isConnected = await Backend.checkFirebaseAvailability();
      if (isConnected) {
        hasConnectivity.value = true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Retry failed: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRetrying = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _autoRetryTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: context.colors.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off, size: 80, color: context.colors.onSurface),
              const SizedBox(height: 24),
              Text(
                'Unable to connect to Firebase',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: context.colors.outlineVariant,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Please check your internet connection and try again',
                style: TextStyle(fontSize: 16, color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _isRetrying ? null : _checkConnectivity,
                icon: _isRetrying
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
                label: Text(_isRetrying ? 'Connecting...' : 'Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
              if (_retryCount > 0) ...[
                const SizedBox(height: 16),
                Text(
                  'Auto-retry in progress... (${_retryCount}/5)',
                  style: TextStyle(fontSize: 12, color: Colors.redAccent),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class WebApp extends StatelessWidget {
  const WebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _MyWebApp();
  }
}

class _MyWebApp extends ConsumerStatefulWidget {
  const _MyWebApp();

  @override
  ConsumerState<_MyWebApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<_MyWebApp> with WidgetsBindingObserver {
  Timer? _connectivityTimer;
  Timer? _periodicConnectivityTimer; // New: Periodic background check
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkConnectivityAndUpdateUser();
      _startPeriodicConnectivityCheck(); // Start background monitoring
    });
  }

  // New: Start periodic connectivity monitoring
  void _startPeriodicConnectivityCheck() {
    _periodicConnectivityTimer = Timer.periodic(const Duration(minutes: 2), (
      timer,
    ) {
      if (_disposed) {
        timer.cancel();
        return;
      }
      _checkConnectivitySilently();
    });
  }

  // New: Silent connectivity check (doesn't update user data)
  Future<void> _checkConnectivitySilently() async {
    if (_disposed) return;

    try {
      final hasInternet = await Backend.checkFirebaseAvailability();
      if (_disposed) return;

      // Only update connectivity status
      hasConnectivity.value = hasInternet;

      if (!hasInternet) {
        print('Firebase connectivity lost during periodic check');
      }
    } catch (e) {
      if (!_disposed) {
        print('Periodic connectivity check error: $e');
        hasConnectivity.value = false;
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (_disposed) return;

    if (state == AppLifecycleState.resumed) {
      _connectivityTimer?.cancel();
      _connectivityTimer = Timer(const Duration(milliseconds: 500), () {
        if (mounted && !_disposed) {
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
    _disposed = true;
    _connectivityTimer?.cancel();
    _periodicConnectivityTimer?.cancel(); // Cancel periodic timer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _checkConnectivityAndUpdateUser() async {
    if (_disposed) return;

    try {
      final hasInternet = await Backend.checkFirebaseAvailability();

      if (_disposed) return;

      hasConnectivity.value = hasInternet;

      if (!hasInternet || !mounted) return;

      try {
        final userModel = await ref
            .read(authControllerProvider.notifier)
            .getUserDataStream()
            .first;

        if (mounted && !_disposed) {
          ref.read(userProvider.notifier).setUser(userModel);
          print('User data updated successfully.');
        }
      } on FirebaseException catch (e) {
        if (!_disposed) {
          print('Firebase Error updating user data: ${e.code} - ${e.message}');

          // Handle specific Firebase errors
          switch (e.code) {
            case 'unavailable':
            case 'deadline-exceeded':
              hasConnectivity.value =
                  false; // These indicate connectivity issues
              break;
            case 'permission-denied':
            case 'not-found':
              // These don't indicate connectivity issues, keep connected status
              break;
          }
        }
      } catch (e) {
        if (!_disposed) {
          print('Generic Error updating user data: $e');
        }
      }
    } catch (e) {
      if (!_disposed) {
        print('Connectivity check error during user data update: $e');
        hasConnectivity.value = false; // Assume no connectivity on error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      // Updated builder with ResponsiveBreakpoints.builder and autoscale functionality
      builder: (context, child) {
        return ResponsiveBreakpoints.builder(
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
          child: Builder(
            builder: (context) => MaxWidthBox(
              maxWidth: 3000,
              backgroundColor: context.colors.surface,
              child: ResponsiveScaledBox(
                width: ResponsiveValue<double>(
                  context,
                  defaultValue: 1200.0,
                  conditionalValues: [
                    Condition.between(start: 0, end: 450, value: 450),
                    Condition.between(start: 451, end: 800, value: 800),
                    Condition.between(start: 801, end: 1200, value: 1200),
                    Condition.between(start: 1201, end: 1500, value: 1500),
                    Condition.between(start: 1501, end: 2000, value: 2000),
                    Condition.between(start: 2001, end: 3000, value: 3000),
                  ],
                ).value,
                child: BouncingScrollWrapper.builder(
                  context,
                  child!,
                  dragWithMouse: true,
                ),
              ),
            ),
          ),
        );
      },
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
  }
}

// Enhanced Backend class with improved Firebase connectivity checking
extension BackendConnectivity on Backend {
  /// Enhanced Firebase availability check with better error handling
  static Future<bool> checkFirebaseAvailability() async {
    try {
      // Try to perform a minimal Firestore operation
      // We don't need the actual data, just need to know if the request succeeds
      await FirebaseFirestore.instance
          .collection('healthCheck')
          .limit(1)
          .get(const GetOptions(source: Source.server)) // Force server check
          .timeout(const Duration(seconds: 5));

      return true; // Successfully connected to Firebase
    } on FirebaseException catch (e) {
      print('Firebase Check Failed: ${e.code} - ${e.message}');

      // Handle specific Firebase error codes
      switch (e.code) {
        case 'permission-denied':
        case 'not-found':
          return true; // Firebase is reachable, just access/permission issues
        case 'unavailable':
        case 'deadline-exceeded':
        case 'resource-exhausted':
          return false; // Connectivity or service availability issues
        case 'unauthenticated':
          return true; // Firebase is reachable, authentication issue
        default:
          return false; // Other errors, assume connectivity issue
      }
    } on TimeoutException {
      print('Firebase Check Timeout');
      return false;
    } catch (e) {
      print('Unexpected Firebase error: $e');
      return false;
    }
  }
}
