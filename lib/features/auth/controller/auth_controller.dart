import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:el_shaddai/core/utility/future_either.dart';
import 'package:el_shaddai/core/widgets/snack_bar.dart';
import 'package:el_shaddai/features/auth/repository/auth_repository.dart';
import 'package:el_shaddai/features/user_management/repository/user_management_repository.dart';
import 'package:el_shaddai/models/user_model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final userProvider = StateProvider<UserModel?>((ref) {
  return null; // Initialize with null
});

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
      authRepository: ref.watch(authRepositoryProvider), ref: ref),
);
final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);
  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithApple(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithApple();
    if (user.isLeft()) {
      showFailureSnackBar(context, 'NO DATA');
    }
    state = false;
    user.fold((l) {
      showFailureSnackBar(context, l.message);
    },
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }

  void deleteUser(
    String uid,
    BuildContext context,
  ) async {
    _authRepository.deleteUserAccount(context, _ref);
    print('tacadwd');
  }

  void signOut() async {
    _authRepository.signOutGoogleAccount();
  }

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();

    if (user.isLeft()) {
      showFailureSnackBar(context, 'NO DATA');
    }

    state = false;
    user.fold((l) {
      showFailureSnackBar(context, l.message);
    },
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }

  Stream<UserModel?> getUserDataStream() async* {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      yield null; // No user logged in
      return;
    }

    // Function to fetch user data with error handling

    // Retry logic with connectivity check
    while (true) {
      try {
        yield* _authRepository.getUserData(
            auth.currentUser!.uid); // Yield the results of the fetch
        break; // If successful, break the loop
      } catch (e) {
        print('Retrying after error: $e');
        // Wait for connectivity to be restored
        final connectivityResult = await (Connectivity()..checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          print('No internet connection. Waiting for connectivity...');
          await for (final connectivityResult
              in Connectivity().onConnectivityChanged) {
            if (connectivityResult != ConnectivityResult.none) {
              print('Internet connection restored!');
              break; // Break the inner loop
            }
          }
        }
        // Wait a short duration before retrying (optional)
        await Future.delayed(const Duration(seconds: 5));
      }
    }
  }
}
