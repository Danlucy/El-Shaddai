// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(posts)
const postsProvider = PostsFamily._();

final class PostsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PostModel>>,
          List<PostModel>,
          Stream<List<PostModel>>
        >
    with $FutureModifier<List<PostModel>>, $StreamProvider<List<PostModel>> {
  const PostsProvider._({
    required PostsFamily super.from,
    required PostType super.argument,
  }) : super(
         retry: null,
         name: r'postsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postsHash();

  @override
  String toString() {
    return r'postsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<PostModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<PostModel>> create(Ref ref) {
    final argument = this.argument as PostType;
    return posts(ref, postType: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PostsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postsHash() => r'64be48141bd04bbf979982d9170c4313600ed70b';

final class PostsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<PostModel>>, PostType> {
  const PostsFamily._()
    : super(
        retry: null,
        name: r'postsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PostsProvider call({required PostType postType}) =>
      PostsProvider._(argument: postType, from: this);

  @override
  String toString() => r'postsProvider';
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
