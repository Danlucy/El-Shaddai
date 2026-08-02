import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final firestoreProvider = Provider(
  (ref) =>
      FirebaseFirestore.instance
        ..settings = const Settings(persistenceEnabled: true),
);

final authProvider = Provider((ref) => FirebaseAuth.instance);

final storageProvider = Provider((ref) => FirebaseStorage.instance);

final googleSignInProvider = Provider<GoogleSignIn>(
  (ref) => GoogleSignIn.instance,
);

Future<void>? _googleSignInInitialization;

/// Initializes the singleton exactly once.
Future<void> initializeGoogleSignIn() {
  return _googleSignInInitialization ??= GoogleSignIn.instance.initialize(
    serverClientId:
        '5347198504-mv7hsnnvvca4k7keda0410t262f95q8q.apps.googleusercontent.com',
  );
}
