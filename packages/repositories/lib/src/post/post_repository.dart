import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:constants/constants.dart';
import 'package:firebase/firebase.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_repository.g.dart';

enum PostType {
  feedPost(FirebaseConstants.feedCollection),
  aboutPost(FirebaseConstants.aboutCollection);

  final String collectionName;

  const PostType(this.collectionName);

  String collection() {
    return collectionName;
  }
}

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
Stream<List<PostModel>> posts(Ref ref, {required PostType postType}) {
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
