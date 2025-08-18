import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance
  ..settings = const Settings(
    persistenceEnabled: true,
  ));

final authProvider = Provider((ref) => FirebaseAuth.instance);

final storageProvider = Provider((ref) => FirebaseStorage.instance);

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  final g = GoogleSignIn.instance;
  // Safe to await somewhere during app boot; here we just fire-and-forget.
  g.initialize(
    clientId: kIsWeb
        ? 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com'
        : (Platform.isIOS
            ? 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com'
            : null),
  );
  return g;
});
