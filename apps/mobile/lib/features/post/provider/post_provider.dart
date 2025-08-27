import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_provider.g.dart';

final currentOrgPostRepositoryProvider = Provider<PostRepository>((ref) {
  // 1. Watch the current organization from your mobile app
  final currentOrg = ref.watch(organizationControllerProvider);

  // 2. Handle the AsyncValue state from organizationControllerProvider
  return currentOrg.when(
    // When organization is loaded successfully
    data: (orgId) => ref.watch(postRepositoryProvider(orgId.name)),

    // When organization is still loading
    loading: () => throw StateError('Organization not loaded'),

    // When there's an error loading organization
    error: (err, stack) => throw err,
  );
});

@riverpod
AsyncValue<List<PostModel>> getCurrentOrgPostsStream(
  Ref ref, {
  required PostType postType,
}) {
  final orgAsync = ref.watch(organizationControllerProvider);
  return orgAsync.when(
    data: (org) => ref.watch(
      currentOrgPostsProvider(organizationId: org.name, postType: postType),
    ),
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
}

@riverpod
AsyncValue<PostModel?> getSingleCurrentOrgPostStream(
  Ref ref, {
  required String postId,
  required PostType postType,
}) {
  final orgAsync = ref.watch(organizationControllerProvider);
  return orgAsync.when(
    data: (org) => ref.watch(
      singleCurrentOrgPostProvider(
        organizationId: org.name,
        postId: postId,
        postType: postType,
      ),
    ),
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
}

// 🔹 **Convenience providers for specific post types**

@riverpod
AsyncValue<List<PostModel>> getCurrentOrgFeedPostsStream(Ref ref) {
  return ref.watch(
    getCurrentOrgPostsStreamProvider(postType: PostType.feedPost),
  );
}

@riverpod
AsyncValue<List<PostModel>> getCurrentOrgAboutPostsStream(Ref ref) {
  return ref.watch(
    getCurrentOrgPostsStreamProvider(postType: PostType.aboutPost),
  );
}

// 🔹 **Post action providers for CRUD operations**

@riverpod
class PostActions extends _$PostActions {
  @override
  void build() {
    // No initial state needed for action providers
  }

  Future<void> addPost(PostModel post, {required PostType postType}) async {
    try {
      final repository = ref.read(currentOrgPostRepositoryProvider);
      await repository.addPost(post, postType: postType);
    } catch (e) {
      throw Exception('Failed to add post: $e');
    }
  }

  Future<void> updatePost(
    PostModel post, {
    required PostType postType,
    required String postId,
  }) async {
    try {
      final repository = ref.read(currentOrgPostRepositoryProvider);
      await repository.updatePost(post, postType: postType, postId: postId);
    } catch (e) {
      throw Exception('Failed to update post: $e');
    }
  }

  Future<void> deletePost(String postId, {required PostType postType}) async {
    try {
      final repository = ref.read(currentOrgPostRepositoryProvider);
      await repository.deletePost(postId, postType: postType);
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }
}
