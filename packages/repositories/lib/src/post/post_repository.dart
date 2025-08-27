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

final postRepositoryProvider = Provider.family<PostRepository, String>((
  ref,
  organizationId,
) {
  return PostRepository(
    firestore: ref.watch(firestoreProvider),
    organizationId: organizationId,
  );
});

class PostRepository {
  final FirebaseFirestore _firestore;
  final String _organizationId;

  PostRepository({
    required FirebaseFirestore firestore,
    required String organizationId,
  }) : _firestore = firestore,
       _organizationId = organizationId;

  CollectionReference postCollection(PostType postType) {
    return _firestore
        .collection(FirebaseConstants.churchesCollection)
        .doc(_organizationId)
        .collection(postType.collection());
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
      final postWithId = post.copyWith(
        id: newPostRef.id,
        createdAt: DateTime.now(),
      ); // Assign ID and timestamp

      await newPostRef.set(postWithId.toJson());
      print('✅ Post added successfully: ${newPostRef.id}');
    } catch (e) {
      print('❌ Error adding post: $e');
      throw Exception('Failed to add post');
    }
  }

  /// 🔹 **Function to Update an existing Post**
  Future<void> updatePost(
    PostModel post, {
    required PostType postType,
    required String postId,
  }) async {
    try {
      final docRef = postCollection(postType).doc(postId);
      final existingPost = await docRef.get();

      if (!existingPost.exists) {
        throw Exception(
          "Post with ID $postId does not exist in organization $_organizationId.",
        );
      }

      final updatedPost = post.copyWith(id: postId);

      await docRef.set(updatedPost.toJson());
      print('✅ Post updated successfully: $postId');
    } catch (e) {
      print('❌ Error updating post: $e');
      throw Exception('Failed to update post');
    }
  }
}

@riverpod
Stream<List<PostModel>> currentOrgPosts(
  Ref ref, {
  required String organizationId,
  required PostType postType,
}) {
  final firestore = ref.watch(firestoreProvider);

  return firestore
      .collection(FirebaseConstants.churchesCollection)
      .doc(organizationId)
      .collection(postType.collection())
      .orderBy(
        'createdAt',
        descending: true,
      ) // Optional: order by creation date
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          final post = PostModel.fromJson({...doc.data(), 'id': doc.id});
          return post;
        }).toList();
      });
}

@riverpod
Stream<PostModel?> singleCurrentOrgPost(
  Ref ref, {
  required String organizationId,
  required String postId,
  required PostType postType,
}) {
  final firestore = ref.watch(firestoreProvider);

  return firestore
      .collection(FirebaseConstants.churchesCollection)
      .doc(organizationId)
      .collection(postType.collection())
      .doc(postId)
      .snapshots()
      .map(
        (doc) => doc.exists
            ? PostModel.fromJson({
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              })
            : null,
      );
}
