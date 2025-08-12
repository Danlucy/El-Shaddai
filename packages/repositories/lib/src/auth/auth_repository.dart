import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:constants/constants.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:models/models.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:util/util.dart';
import 'dart:io';

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
        clientId: Platform.isIOS
            ? '835474148480-81mvj92hhksksbsqd5c9k717coa6vm92.apps.googleusercontent.com'
            : null,
      );
      _isGoogleSignInInitialized = true;
    } catch (e) {
      print('Failed to initialize Google Sign-In: $e');
    }
  }

  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isGoogleSignInInitialized) {
      await _initializeGoogleSignIn();
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
      AuthCredential credential;
      if (user.providerData
          .any((info) => info.providerId == GoogleAuthProvider().providerId)) {
        // Google re-authentication - using new v7 API
        await _ensureGoogleSignInInitialized();
        await _googleSignIn.signOut();

        try {
          // Use the new authenticate method
          final GoogleSignInAccount googleUser =
              await _googleSignIn.authenticate(
            scopeHint: ['email', 'profile'],
          );

          // Get authorization for Firebase
          final authClient = _googleSignIn.authorizationClient;
          final authorization =
              await authClient.authorizationForScopes(['email', 'profile']);

          if (authorization == null) {
            return left(Failure('Failed to get Google authorization'));
          }

          // Get authentication tokens (now synchronous)
          final googleAuth = googleUser.authentication;

          credential = GoogleAuthProvider.credential(
            accessToken: authorization.accessToken,
            idToken: googleAuth.idToken,
          );

          await user.reauthenticateWithCredential(credential);
          print('User re-authenticated with Google successfully');
          return right(true);
        } on GoogleSignInException catch (e) {
          return left(
              Failure('Google re-authentication failed: ${e.description}'));
        } catch (e) {
          return left(
              Failure('Google re-authentication failed: ${e.toString()}'));
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

  Future<void> signOutGoogleAccount() async {
    try {
      // Sign out from Google Sign-In (disconnect the account)
      await _googleSignIn.signOut();
      print('Google Sign-In account disconnected');
    } catch (e) {
      print('Error signing out from Google Sign-In: $e');
    }
    try {
      await FirebaseAuth.instance.signOut();
      print('Firebase Authentication user signed out');
    } catch (e) {
      print('Error signing out from Firebase Authentication: $e');
    }
  }

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();

      // Use the new authenticate method
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );

      // Get authorization for Firebase scopes
      final authClient = _googleSignIn.authorizationClient;
      final authorization =
          await authClient.authorizationForScopes(['email', 'profile']);

      if (authorization == null) {
        return left(Failure('Failed to get Google authorization'));
      }

      // Get authentication tokens (now synchronous)
      final googleAuth = googleUser.authentication;

      if (googleAuth.idToken == null) {
        return left(Failure('Google authentication failed - missing tokens'));
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: authorization.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ?? 'Nameless',
          uid: userCredential.user!.uid,
          role: UserRole.observer,
        );
        await _users.doc(userCredential.user?.uid).set(userModel.toJson());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }

      return right(userModel);
    } on GoogleSignInException catch (e) {
      return left(Failure('Google Sign-In failed: ${e.description}'));
    } on FirebaseException catch (e) {
      return left(Failure(e.message ?? 'Firebase error occurred'));
    } catch (e) {
      return left(Failure('An unexpected error occurred: ${e.toString()}'));
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
}
