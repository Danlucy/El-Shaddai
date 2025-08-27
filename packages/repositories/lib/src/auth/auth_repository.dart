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

import '../user_management/user_management_repository.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  }) : _firestore = firestore,
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
            ? '5347198504-mv7hsnnvvca4k7keda0410t262f95q8q.apps.googleusercontent.com'
            : null,
      );
    } catch (e) {
      print('Failed to initialize Google Sign-In: $e');
    }
  }

  // EXTRACTED METHOD - Handles user creation/retrieval logic
  Future<UserModel> _handleUserCreationOrRetrieval({
    required UserCredential userCredential,
  }) async {
    // Get a reference to the user document
    final docRef = _users.doc(userCredential.user!.uid);
    final docSnapshot = await docRef.get();

    // Check if the document exists OR if it's a brand new user
    if (!docSnapshot.exists ||
        userCredential.additionalUserInfo?.isNewUser == true) {
      // If it doesn't exist or is new, create it.
      final userModel = UserModel(
        createdAt: DateTime.now(),
        name: userCredential.user?.displayName ?? 'Nameless',
        uid: userCredential.user!.uid,
        roles: {},
      );
      await docRef.set(userModel.toJson());
      return userModel;
    } else {
      print('222');

      // If it exists, parse and return the existing data.
      return UserModel.fromJson(docSnapshot.data() as Map<String, dynamic>);
    }
  }

  // SIMPLIFIED Apple sign-in method
  FutureEither<UserModel> signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider()..addScope('email');
      final userCredential = await _auth.signInWithProvider(appleProvider);

      final userModel = await _handleUserCreationOrRetrieval(
        userCredential: userCredential,
      );

      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // SIMPLIFIED Google sign-in method
  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount account = await _googleSignIn.authenticate(
        scopeHint: const ['email', 'profile'],
      );

      final idToken = account.authentication.idToken;
      if (idToken == null) {
        return left(Failure('Google authentication failed: missing ID token.'));
      }

      final authz = await _googleSignIn.authorizationClient
          .authorizationForScopes(const ['email', 'profile']);
      final accessToken = authz?.accessToken;

      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);

      final userModel = await _handleUserCreationOrRetrieval(
        userCredential: userCredential,
      );
      print(userModel);
      return right(userModel);
    } on FirebaseException catch (e) {
      return left(Failure(e.message ?? 'Firebase error.'));
    } catch (e) {
      return left(Failure('Google sign-in failed: $e'));
    }
  }

  FutureEither<bool> reauthenticateUser(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return left(Failure('No user found'));
    }

    try {
      AuthCredential? credential;

      if (user.providerData.any(
        (info) => info.providerId == GoogleAuthProvider().providerId,
      )) {
        // Google re-authentication
        await _googleSignIn.signOut();

        try {
          final account = await _googleSignIn.authenticate(
            scopeHint: const ['email', 'profile'],
          );

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
      } else if (user.providerData.any(
        (info) => info.providerId == AppleAuthProvider().providerId,
      )) {
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

  FutureEither<void> deleteUserAccount(
    BuildContext context,
    Ref ref, {
    Function(BuildContext)? onSuccess,
  }) async {
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
                : failure.message,
          );
          return left(failure);
        },
        (success) async {
          try {
            await ref
                .read(userManagementRepositoryProvider(null))
                .clearUserDataExcept(currentUser.uid);

            await currentUser.delete();
            await _auth.signOut();

            if (onSuccess != null) {
              onSuccess(context);
            }

            return right(null);
          } on FirebaseException catch (e) {
            return left(
              Failure(
                e.message ?? 'Firebase error occurred during account deletion',
              ),
            );
          } catch (e) {
            return left(Failure('Failed to delete account: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      return left(Failure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    try {
      return _users.doc(uid).snapshots().map((event) {
        return UserModel.fromJson(event.data() as Map<String, dynamic>);
      });
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

  Future<void> removeOldRoleFieldFromAllUsers() async {
    final firestore = FirebaseFirestore.instance;
    final usersCollection = firestore.collection('users');

    debugPrint(
      '🧹 Starting cleanup: Removing old "role" field from all users...',
    );

    try {
      final snapshot = await usersCollection.get();
      if (snapshot.docs.isEmpty) {
        debugPrint('❌ No users found.');
        return;
      }

      final batch = firestore.batch();
      int documentsToUpdate = 0;
      int documentsSkipped = 0;
      int documentsNoRole = 0;
      int documentsNoRoles = 0;

      for (final doc in snapshot.docs) {
        final data = doc.data();

        debugPrint('🔍 Processing user: ${doc.id}');

        final hasRole = data.containsKey('role');
        final hasRoles = data.containsKey('roles');

        if (hasRole && hasRoles) {
          // Safe to remove old 'role' field since 'roles' exists
          batch.update(doc.reference, {'role': FieldValue.delete()});
          documentsToUpdate++;
          debugPrint('   ✅ Will remove old "role" field');
        } else if (hasRole && !hasRoles) {
          // Don't remove 'role' if 'roles' doesn't exist (migration failed?)
          documentsSkipped++;
          debugPrint(
            '   ⚠️  Skipped: has "role" but no "roles" field (migration incomplete?)',
          );
        } else if (!hasRole && hasRoles) {
          // Already cleaned up
          documentsNoRole++;
          debugPrint('   ✅ Already cleaned: no "role" field, has "roles"');
        } else {
          // Neither field exists
          documentsNoRoles++;
          debugPrint('   ❌ No "role" or "roles" field found');
        }
      }

      debugPrint('\n📊 CLEANUP SUMMARY BEFORE COMMIT:');
      debugPrint('   Documents to clean: $documentsToUpdate');
      debugPrint('   Already cleaned: $documentsNoRole');
      debugPrint('   Skipped (unsafe): $documentsSkipped');
      debugPrint('   No roles field: $documentsNoRoles');

      if (documentsToUpdate > 0) {
        debugPrint('\n🔄 Committing batch deletion...');
        await batch.commit();
        debugPrint(
          '✅ Successfully removed old "role" field from $documentsToUpdate user documents!',
        );

        if (documentsSkipped > 0) {
          debugPrint(
            '⚠️  WARNING: $documentsSkipped users still have "role" field but no "roles" field.',
          );
          debugPrint('   These users may need re-migration.');
        }
      } else {
        debugPrint('\n🤷‍♂️ No old "role" fields to remove.');
        if (documentsNoRole > 0) {
          debugPrint('   ✅ $documentsNoRole users already cleaned up');
        }
        if (documentsSkipped > 0) {
          debugPrint('   ⚠️  $documentsSkipped users need migration first');
        }
      }
    } catch (e) {
      debugPrint('❌ An error occurred during cleanup: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      rethrow;
    }
  }
}
