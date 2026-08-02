import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/controller/auth_controller.dart';
import '../provider/post_provider.dart';
import '../state/post_state.dart';

part 'post_controller.g.dart';

@riverpod
class PostController extends _$PostController {
  @override
  PostState build() {
    return const PostState();
  }

  /// ✅ **Pick & Compress Image**
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (imageFile != null) {
      final Uint8List compressedImage = await _compressImage(imageFile);

      state = state.copyWith(
        image: compressedImage,
      ); // ✅ Updates state & triggers rebuild
    }
  }

  /// ✅ **Compress & Resize Image**
  Future<Uint8List> _compressImage(XFile imageFile) async {
    final File file = File(imageFile.path);
    final Uint8List imageBytes = await file.readAsBytes();

    // ✅ Decode image
    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) return imageBytes; // Return original if decoding fails

    // ✅ Adaptive Resize Logic
    int targetWidth = image.width > 500
        ? 350
        : image.width + 150; // Resize if width > 500px
    final img.Image resizedImage = img.copyResize(image, width: targetWidth);

    // ✅ Adjust Compression Quality
    final Uint8List compressedBytes = Uint8List.fromList(
      img.encodeJpg(
        resizedImage,
        quality: 85,
      ), // 🔥 Increased to 75 for better quality
    );

    return compressedBytes;
  }

  void deletePost(String postId, {required PostType postType}) {
    try {
      ref
          .read(currentOrgPostRepositoryProvider)
          .deletePost(postId, postType: postType);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error deleting post: $e');
      }
    }
  }

  void addPost({required PostType postType, PostModel? post}) {
    try {
      final user = ref.read(userProvider).value;
      final title = state.title ?? post?.title;
      final description = state.description ?? post?.content;

      if (title != null && description != null) {
        final updatedPost = PostModel(
          title: title,
          content: description,
          image: state.image ?? post?.image,
          id: FirebaseFirestore.instance.collection('dog').doc().id,
          userId: post?.userId ?? user!.uid,
          createdAt: post?.createdAt ?? DateTime.now(),
        );
        final repository = ref.read(currentOrgPostRepositoryProvider);

        if (post != null) {
          repository.updatePost(
            updatedPost,
            postType: postType,
            postId: post.id,
          );
        } else {
          repository.addPost(updatedPost, postType: postType);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error adding post: $e');
      }
    }
  }

  void setTitle(String title) => state = state.copyWith(title: title);

  void setDescription(String description) {
    state = state.copyWith(description: description);
  }
}
