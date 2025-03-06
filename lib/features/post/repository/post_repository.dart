import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_shaddai/core/firebase_providers.dart';
import 'package:el_shaddai/features/post/controller/post_controller.dart';
import 'package:el_shaddai/models/post_model/post_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_repository.g.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference postCollection(PostType postType) {
    return _firestore.collection(postType.collection());
  }

  Future<void> deletePost(String postId, {required PostType postType}) async {
    try {
      await postCollection(postType).doc(postId).delete();
      print('✅ Post deleted successfully: $postId');
    } catch (e) {
      print('❌ Error deleting post: $e');
      throw Exception('Failed to delete post');
    }
  }

  /// 🔹 **Function to Add a Post to Firestore**
  Future<void> addPost(PostModel post, {required PostType postType}) async {
    try {
      final newPostRef = postCollection(postType).doc();
      final postWithId = post.copyWith(id: newPostRef.id); // Assign ID

      await newPostRef.set(postWithId.toJson());
      // Generate a new document ID
      // Save to Firestore
    } catch (e) {
      print('❌ Error adding post: $e');
      throw Exception('Failed to add post');
    }
  }
}

@riverpod
Stream<List<PostModel>> posts(PostsRef ref, {required PostType postType}) {
  final firestore = ref.watch(firestoreProvider);

  return firestore
      .collection(postType.collection())
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      final post = PostModel.fromJson({...doc.data(), 'id': doc.id});
      return post;
    }).toList();
  });
}
