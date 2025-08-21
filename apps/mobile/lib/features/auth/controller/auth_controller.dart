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

final userProvider = NotifierProvider<UserNotifier, UserModel?>(
  () => UserNotifier(),
);

// User notifier class
class UserNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() {
    return null; // Initialize with null
  }

  void setUser(UserModel? user) {
    state = user;
  }

  void clearUser() {
    state = null;
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
  final currentUser = FirebaseAuth.instance.currentUser;

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

      if (user.isLeft()) {
        showFailureSnackBar(context, 'NO DATA');
        state = const AsyncValue.error('NO DATA', StackTrace.empty);
        return;
      }

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
      showFailureSnackBar(context, e.toString());
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
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      ref
          .read(profileControllerProvider(uid).notifier)
          .updateUserField('fcmToken', newToken);
    });
    final initialToken = await FirebaseMessaging.instance.getToken();
    if (initialToken != null) {
      ref
          .read(profileControllerProvider(currentUser!.uid).notifier)
          .updateUserField('fcmToken', initialToken);
    }
  }
}
