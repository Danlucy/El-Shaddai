import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:constants/constants.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:models/models.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:util/util.dart';

import '../user_management/user_management_repository.dart'; // <-- IMPORTANT: Ensure this is uncommented

final authRepositoryProvider = Provider((ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider)));

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  bool _isGoogleSignInInitialized = false;

  AuthRepository(
      {required FirebaseFirestore firestore,
      required FirebaseAuth auth,
      required GoogleSignIn googleSignIn})
      : _firestore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn {
    _initializeGoogleSignIn();
  }

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
  Stream<User?> get authStateChange => _auth.authStateChanges();

  Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize(
        clientId:
            kIsWeb || Platform.isMacOS || Platform.isWindows || Platform.isLinux
                ? '.apps.googleusercontent.com'
                : null,
      );
      _isGoogleSignInInitialized = true;
    } catch (e) {
      print('Failed to initialize Google Sign-In: $e');
    }
  }

  FutureEither<UserModel> signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider()..addScope('email');
      final userCredential = await _auth.signInWithProvider(appleProvider);
      UserModel userModel;
      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ?? 'Nameless',
          uid: userCredential.user!.uid,
          role: UserRole.intercessor,
        );
        await _users.doc(userCredential.user?.uid).set(userModel.toJson());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }

      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<bool> reauthenticateUser(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return left(Failure('No user found'));
    }

    try {
      AuthCredential? credential;

      if (user.providerData
          .any((info) => info.providerId == GoogleAuthProvider().providerId)) {
        // Google re-authentication
        await _googleSignIn.signOut();

        try {
          final account = await _googleSignIn
              .authenticate(scopeHint: const ['email', 'profile']);

          final idToken = account.authentication.idToken;
          if (idToken == null) {
            return left(Failure('Missing Google ID token.'));
          }

          final authz = await _googleSignIn.authorizationClient
              .authorizationForScopes(const ['email', 'profile']);

          final credential = GoogleAuthProvider.credential(
            idToken: idToken,
            accessToken: authz?.accessToken,
          );

          await user.reauthenticateWithCredential(credential);
          return right(true);
        } catch (e) {
          return left(Failure('Google re-authentication failed: $e'));
        }
      } else if (user.providerData
          .any((info) => info.providerId == AppleAuthProvider().providerId)) {
        // Apple re-authentication
        try {
          final appleResult = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
          );

          if (appleResult.email == user.email) {
            OAuthProvider appleProvider = OAuthProvider('apple.com');
            credential = appleProvider.credential(
              idToken: appleResult.identityToken,
              accessToken: appleResult.authorizationCode,
            );
            await user.reauthenticateWithCredential(credential);
            print("Re-authentication with Apple successful!");
            return right(true);
          } else {
            print('Apple Sign-In cancelled');
            return left(Failure('Apple sign in Error'));
          }
        } catch (e) {
          return left(Failure("Apple: ${e.toString()}"));
        }
      } else {
        return left(Failure('Method is not supported'));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<void> deleteUserAccount(BuildContext context, Ref ref,
      {Function(BuildContext)? onSuccess}) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        return left(Failure('No user is currently signed in'));
      }

      final reauthResult = await reauthenticateUser(context);

      return reauthResult.fold(
        (failure) {
          showFailureSnackBar(
              context,
              (failure.message.contains('credentials do not correspond') ||
                      failure.message.contains('previously signed in user'))
                  ? 'Sign In With Your OWN Account'
                  : failure.message);
          return left(failure);
        },
        (success) async {
          try {
            await ref
                .read(userManagementRepositoryProvider)
                .clearUserDataExcept(currentUser.uid);

            await currentUser.delete();
            await _auth.signOut();

            // New Logic: Check for the optional callback
            if (onSuccess != null) {
              onSuccess(context);
            }

            return right(null);
          } on FirebaseException catch (e) {
            return left(Failure(e.message ??
                'Firebase error occurred during account deletion'));
          } catch (e) {
            return left(Failure('Failed to delete account: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      return left(Failure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      // 1) Start Google sign-in (scopes go here now)
      final GoogleSignInAccount account = await _googleSignIn
          .authenticate(scopeHint: const ['email', 'profile']);

      // 2) Get ID token (accessToken moved elsewhere in v7)
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        return left(Failure('Google authentication failed: missing ID token.'));
      }

      // 3) (Optional) Ask for an OAuth access token if you want one
      final authz = await _googleSignIn.authorizationClient
          .authorizationForScopes(const ['email', 'profile']);
      final accessToken = authz?.accessToken;

      // 4) Use with Firebase
      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken, // optional
      );
      final userCred = await _auth.signInWithCredential(credential);

      // 5) Create or fetch your app user
      late final UserModel userModel;
      if (userCred.additionalUserInfo?.isNewUser == true) {
        userModel = UserModel(
          name: userCred.user?.displayName ?? 'Nameless',
          uid: userCred.user!.uid,
          role: UserRole.observer,
        );
        await _users.doc(userCred.user!.uid).set(userModel.toJson());
      } else {
        userModel = await getUserData(userCred.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      return left(Failure(e.message ?? 'Firebase error.'));
    } catch (e) {
      return left(Failure('Google sign-in failed: $e'));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    try {
      return _users.doc(uid).snapshots().map(
        (event) {
          return UserModel.fromJson(event.data() as Map<String, dynamic>);
        },
      );
    } catch (e) {
      throw 'USER NOT FOUND, check internet.';
    }
  }

  Future<void> signOutGoogleAccount() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Error during sign out: $e');
    }
  }
}
