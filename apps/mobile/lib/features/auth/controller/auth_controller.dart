import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/profile/controller/profile_controller.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:util/util.dart';

final userProvider = NotifierProvider<UserNotifier, AsyncValue<UserModel?>>(
  () => UserNotifier(),
);

// User notifier class
class UserNotifier extends Notifier<AsyncValue<UserModel?>> {
  @override
  AsyncValue<UserModel?> build() {
    return const AsyncValue.loading(); // instead of null
  }

  void setUser(UserModel user) {
    state = AsyncValue.data(user);
  }

  void clearUser() {
    state = const AsyncValue.data(null);
  }
}

// Updated to use AsyncNotifierProvider
final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  () => AuthController(),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

// Updated to extend AsyncNotifier instead of StateNotifier
class AuthController extends AsyncNotifier<void> {
  late AuthRepository _authRepository;

  @override
  Future<void> build() async {
    _authRepository = ref.watch(authRepositoryProvider);
    // Initialize with void/empty state
  }

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  Future<void> signInWithApple(BuildContext context) async {
    state = const AsyncValue.loading();

    try {
      final user = await _authRepository.signInWithApple();

      if (user.isLeft()) {
        showFailureSnackBar(context, 'NO DATA');
        state = const AsyncValue.error('NO DATA', StackTrace.empty);
        return;
      }

      user.fold(
        (l) {
          showFailureSnackBar(context, l.message);
          state = AsyncValue.error(l.message, StackTrace.empty);
        },
        (userModel) {
          ref.read(userProvider.notifier).setUser(userModel);
          state = const AsyncValue.data(null);
        },
      );
    } catch (e, stackTrace) {
      showFailureSnackBar(context, e.toString());
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteUser(String uid, BuildContext context) async {
    state = const AsyncValue.loading();

    try {
      await _authRepository.deleteUserAccount(context, ref);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();

    try {
      await _authRepository.signOutGoogleAccount();
      ref.read(userProvider.notifier).clearUser();
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    state = const AsyncValue.loading();

    try {
      final user = await _authRepository.signInWithGoogle();

      // Check if the widget is still mounted before proceeding
      if (!context.mounted) return;

      user.fold(
        (l) {
          if (kDebugMode) {
            print('Error signing in with Google: ${l.message}');
          }
          showFailureSnackBar(context, l.message);
          state = AsyncValue.error(l.message, StackTrace.empty);
        },
        (userModel) {
          ref.read(userProvider.notifier).setUser(userModel);
          state = const AsyncValue.data(null);
        },
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error signing in with Google: $e');
      }
      // Also check here before showing the snackbar for a general catch
      if (context.mounted) {
        showFailureSnackBar(context, e.toString());
      }
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Stream<UserModel?> getUserDataStream() async* {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      yield null; // No user logged in
      return;
    }
    // Listen for FCM token refresh
    _initAndUpdateFCMToken(auth.currentUser!.uid);
    // Save initial token

    // Retry logic with connectivity check
    while (true) {
      try {
        yield* _authRepository.getUserData(auth.currentUser!.uid);
        break; // If successful, break the loop
      } catch (e) {
        if (kDebugMode) {
          print('Retrying after error: $e');
          print('Waiting for connectivity...');
        }
        await Future.delayed(const Duration(seconds: 5));
      }
    }
  }

  void _initAndUpdateFCMToken(String uid) async {
    // Listen for Token Refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      // ✅ Use the 'uid' passed into this function!
      ref
          .read(profileControllerProvider(uid).notifier)
          .updateUserField('fcmToken', newToken);
    });

    // Get Initial Token
    final initialToken = await FirebaseMessaging.instance.getToken();
    if (initialToken != null) {
      // ✅ Use the 'uid' passed into this function!
      ref
          .read(profileControllerProvider(uid).notifier)
          .updateUserField('fcmToken', initialToken);
    }
  }
}
