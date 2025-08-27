// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(currentOrgPosts)
const currentOrgPostsProvider = CurrentOrgPostsFamily._();

final class CurrentOrgPostsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PostModel>>,
          List<PostModel>,
          Stream<List<PostModel>>
        >
    with $FutureModifier<List<PostModel>>, $StreamProvider<List<PostModel>> {
  const CurrentOrgPostsProvider._({
    required CurrentOrgPostsFamily super.from,
    required ({String organizationId, PostType postType}) super.argument,
  }) : super(
         retry: null,
         name: r'currentOrgPostsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$currentOrgPostsHash();

  @override
  String toString() {
    return r'currentOrgPostsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<PostModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<PostModel>> create(Ref ref) {
    final argument =
        this.argument as ({String organizationId, PostType postType});
    return currentOrgPosts(
      ref,
      organizationId: argument.organizationId,
      postType: argument.postType,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentOrgPostsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$currentOrgPostsHash() => r'0e2db4cc33f001822859a0f9183a7525264414d3';

final class CurrentOrgPostsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<List<PostModel>>,
          ({String organizationId, PostType postType})
        > {
  const CurrentOrgPostsFamily._()
    : super(
        retry: null,
        name: r'currentOrgPostsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CurrentOrgPostsProvider call({
    required String organizationId,
    required PostType postType,
  }) => CurrentOrgPostsProvider._(
    argument: (organizationId: organizationId, postType: postType),
    from: this,
  );

  @override
  String toString() => r'currentOrgPostsProvider';
}

@ProviderFor(singleCurrentOrgPost)
const singleCurrentOrgPostProvider = SingleCurrentOrgPostFamily._();

final class SingleCurrentOrgPostProvider
    extends
        $FunctionalProvider<
          AsyncValue<PostModel?>,
          PostModel?,
          Stream<PostModel?>
        >
    with $FutureModifier<PostModel?>, $StreamProvider<PostModel?> {
  const SingleCurrentOrgPostProvider._({
    required SingleCurrentOrgPostFamily super.from,
    required ({String organizationId, String postId, PostType postType})
    super.argument,
  }) : super(
         retry: null,
         name: r'singleCurrentOrgPostProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$singleCurrentOrgPostHash();

  @override
  String toString() {
    return r'singleCurrentOrgPostProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<PostModel?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<PostModel?> create(Ref ref) {
    final argument =
        this.argument
            as ({String organizationId, String postId, PostType postType});
    return singleCurrentOrgPost(
      ref,
      organizationId: argument.organizationId,
      postId: argument.postId,
      postType: argument.postType,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SingleCurrentOrgPostProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$singleCurrentOrgPostHash() =>
    r'b281b26194fa5ecef54843264789d50841649ab5';

final class SingleCurrentOrgPostFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<PostModel?>,
          ({String organizationId, String postId, PostType postType})
        > {
  const SingleCurrentOrgPostFamily._()
    : super(
        retry: null,
        name: r'singleCurrentOrgPostProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SingleCurrentOrgPostProvider call({
    required String organizationId,
    required String postId,
    required PostType postType,
  }) => SingleCurrentOrgPostProvider._(
    argument: (
      organizationId: organizationId,
      postId: postId,
      postType: postType,
    ),
    from: this,
  );

  @override
  String toString() => r'singleCurrentOrgPostProvider';
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
