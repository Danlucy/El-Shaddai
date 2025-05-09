import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_shaddai/core/constants/firebase_constants.dart';
import 'package:el_shaddai/core/firebase_providers.dart';
import 'package:el_shaddai/core/utility/failure.dart';
import 'package:el_shaddai/core/utility/future_either.dart';
import 'package:el_shaddai/core/widgets/snack_bar.dart';
import 'package:el_shaddai/features/user_management/repository/user_management_repository.dart';
import 'package:el_shaddai/models/user_model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider)));

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository(
      {required FirebaseFirestore firestore,
      required FirebaseAuth auth,
      required GoogleSignIn googleSignIn})
      : _firestore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn;
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
  Stream<User?> get authStateChange => _auth.authStateChanges();

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
      return left(Failure('No user found')); // Return a Failure if no user
    }

    try {
      AuthCredential credential;
      if (user.providerData
          .any((info) => info.providerId == GoogleAuthProvider().providerId)) {
        // Google re-authentication - initiate the Google Sign-In flow again
        await _googleSignIn.signOut();
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          return left(Failure('Google Sign-In cancelled'));
        }

        final googleAuth = await googleUser.authentication;

        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await user.reauthenticateWithCredential(credential);
        print('User re-authenticated with Google successfully');
        return right(
            true); //Return to success on successful authentication with google.
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
          //SAMUEL HELP HERE ID ONT KNOW APPLE SHIT I CANT TEST IT

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
            return left(Failure('Apple sign in Error')); //Throw apple sign in
          }
        } catch (e) {
          return left(Failure("Apple: ${e.toString()}")); //Handle errors
        }
      } else {
        return left(Failure('Method is not supported'));
      }

      throw 'Should not reach here'; //I had a throw previously before.
    } catch (e) {
      return left(
          Failure(e.toString())); //Generic handler. Catch any other exception
    }
  }

  FutureEither<void> deleteUserAccount(BuildContext context, Ref ref) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        return left(Failure('No user is currently signed in'));
      }

      // First re-authenticate the user
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

            // Then delete the Firebase Authentication account
            await currentUser.delete();

            // Sign out after successful deletion
            await _auth.signOut();

            showSuccessfulSnackBar(context, 'Account deleted successfully');
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
      await GoogleSignIn().signOut();

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
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      UserModel userModel;
      // print(userCredential);

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
      print('Error signing in with Google: $e');
      print(e);
      return left(
        Failure(
          'An error occurred while signing in with Google. Please try again.',
        ),
      );
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
