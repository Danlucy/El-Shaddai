import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/widgets/snack_bar.dart';
import 'package:mobile/features/user_management/provider/user_management_provider.dart';
import 'package:repositories/repositories.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:util/util.dart';

import '../../auth/controller/auth_controller.dart';

part 'user_management_controller.g.dart';

@Riverpod(keepAlive: true)
class UserManagementController extends _$UserManagementController {
  @override
  void build() {}

  void changeUserRole(String uid, String role) {
    ref
        .read(currentUserManagementRepositoryProvider)
        .updateUserRole(uid: uid, role: role);
  }

  Future<void> deleteUserAccount(
    BuildContext context,
    String targetUid, {
    Function(BuildContext)? onSuccess,
  }) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? currentUser = auth.currentUser;
    // Assuming you have a provider that holds the current user's data
    final String? currentUid = ref.read(userProvider).value?.uid;

    if (currentUser == null || currentUid == null) {
      showFailureSnackBar(context, 'No user is currently signed in');
      return;
    }

    try {
      // ==========================================
      // SCENARIO 1: User is deleting their OWN account
      // ==========================================
      if (targetUid == currentUid) {
        // Reauth is required by Firebase to prevent 'requires-recent-login' errors
        final reauthResult = await ref
            .read(authRepositoryProvider)
            .reauthenticateUser(context);

        reauthResult.fold(
          (failure) {
            showFailureSnackBar(
              context,
              (failure.message.contains('credentials do not correspond') ||
                      failure.message.contains('previously signed in user'))
                  ? 'Sign In With Your OWN Account'
                  : failure.message,
            );
          },
          (success) async {
            // 1. Delete Firestore Footprint (Profile & Bookings)
            await ref
                .read(currentUserManagementRepositoryProvider)
                .deleteUserAccount(targetUid);

            // 2. Delete actual Firebase Auth Account
            await currentUser.delete();
            await auth.signOut();

            if (onSuccess != null) {
              onSuccess(context);
            }
          },
        );
      }
      // ==========================================
      // SCENARIO 2: Admin is deleting SOMEONE ELSE'S account
      // ==========================================
      else {
        // 1. Delete Firestore Footprint (Profile & Bookings)
        await ref
            .read(currentUserManagementRepositoryProvider)
            .deleteUserAccount(targetUid);

        // NOTE: We do NOT call currentUser.delete() here, otherwise the Admin
        // deletes their own account! The target user's Auth credential remains
        // intact unless handled via a Cloud Function.
        try {
          final HttpsCallable callable = FirebaseFunctions.instance
              .httpsCallable('deleteUserAuth');
          await callable.call(<String, dynamic>{'uid': targetUid});
        } catch (e) {
          print('Cloud Function Error: $e');
          showFailureSnackBar(
            context,
            'Data deleted, but failed to remove Auth credential.',
          );
          return; // Stop execution if this fails
        }

        if (onSuccess != null) {
          onSuccess(context);
        }
        showSuccessfulSnackBar(
          context,
          'User data and Auth account successfully wiped.',
        );

        showSuccessfulSnackBar(context, 'User data successfully wiped.');
      }
    } on FirebaseException catch (e) {
      showFailureSnackBar(
        context,
        e.message ?? 'Firebase error occurred during account deletion',
      );
    } catch (e) {
      showFailureSnackBar(context, 'Failed to delete account: ${e.toString()}');
    }
  }
}
