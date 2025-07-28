import 'dart:io';
import 'dart:typed_data';
import 'dart:convert'; // For Base64 encoding
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../auth/controller/auth_controller.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  Stream<Map<String, dynamic>> build(String? uid) async* {
    final user = ref.watch(userProvider);
    if (user == null) yield {};

    final userRef = FirebaseFirestore.instance
        .collection(FirebaseConstants.usersCollection)
        .doc(uid ?? user?.uid);

    yield* userRef.snapshots().map((snapshot) => snapshot.data() ?? {});
  }

  /// ✅ **Get list of nullable fields in the user model**
  /// ✅ **Update Firestore Field**
  Future<void> updateUserField(String fieldName, dynamic newValue) async {
    final user = ref.read(userProvider);
    if (user == null) return;

    final userRef = FirebaseFirestore.instance
        .collection(FirebaseConstants.usersCollection)
        .doc(uid ?? user.uid);

    await userRef.update({fieldName: newValue});
  }

  /// ✅ **Pick, Compress & Save Image as Base64 in Firestore**
  Future<Uint8List?> pickAndSaveImage() async {
    final user = ref.read(userProvider);
    if (user == null) return null;

    final ImagePicker picker = ImagePicker();
    final XFile? imageFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      // ✅ Compress & Resize Image
      final Uint8List compressedImage = await _compressImage(imageFile);

      // ✅ Update Firestore (in background)
      updateUserField('image', compressedImage);

      return compressedImage; // Return image to update UI immediately
    }
    return null;
  }

  void deleteImage() {
    updateUserField('image', null);
  }

  void checkFirestoreDocumentSize(Map<String, dynamic> documentData) {
    final jsonString = jsonEncode(documentData);
    final sizeInBytes = utf8.encode(jsonString).length;
    final sizeInKB = sizeInBytes / 1024;
    if (kDebugMode) {
      print('Document Size: $sizeInKB KB');
    }
  }

  /// 🔹 **Smart Compress & Resize Image**
  Future<Uint8List> _compressImage(XFile imageFile) async {
    final File file = File(imageFile.path);
    final Uint8List imageBytes = await file.readAsBytes();

    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) return imageBytes;

    int targetWidth = image.width > 500 ? 250 : image.width + 50;
    final img.Image resizedImage = img.copyResize(image, width: targetWidth);

    final Uint8List compressedBytes = Uint8List.fromList(
      img.encodeJpg(resizedImage, quality: 75),
    );

    return compressedBytes;
  }
}
