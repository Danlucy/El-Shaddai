// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(getCurrentOrgPostsStream)
const getCurrentOrgPostsStreamProvider = GetCurrentOrgPostsStreamFamily._();

final class GetCurrentOrgPostsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PostModel>>,
          AsyncValue<List<PostModel>>,
          AsyncValue<List<PostModel>>
        >
    with $Provider<AsyncValue<List<PostModel>>> {
  const GetCurrentOrgPostsStreamProvider._({
    required GetCurrentOrgPostsStreamFamily super.from,
    required PostType super.argument,
  }) : super(
         retry: null,
         name: r'getCurrentOrgPostsStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getCurrentOrgPostsStreamHash();

  @override
  String toString() {
    return r'getCurrentOrgPostsStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<List<PostModel>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<PostModel>> create(Ref ref) {
    final argument = this.argument as PostType;
    return getCurrentOrgPostsStream(ref, postType: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<PostModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<PostModel>>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetCurrentOrgPostsStreamProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getCurrentOrgPostsStreamHash() =>
    r'5d8cbb81c7609b9cfd67978250fa9459a37a7a0f';

final class GetCurrentOrgPostsStreamFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<List<PostModel>>, PostType> {
  const GetCurrentOrgPostsStreamFamily._()
    : super(
        retry: null,
        name: r'getCurrentOrgPostsStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetCurrentOrgPostsStreamProvider call({required PostType postType}) =>
      GetCurrentOrgPostsStreamProvider._(argument: postType, from: this);

  @override
  String toString() => r'getCurrentOrgPostsStreamProvider';
}

@ProviderFor(getSingleCurrentOrgPostStream)
const getSingleCurrentOrgPostStreamProvider =
    GetSingleCurrentOrgPostStreamFamily._();

final class GetSingleCurrentOrgPostStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<PostModel?>,
          AsyncValue<PostModel?>,
          AsyncValue<PostModel?>
        >
    with $Provider<AsyncValue<PostModel?>> {
  const GetSingleCurrentOrgPostStreamProvider._({
    required GetSingleCurrentOrgPostStreamFamily super.from,
    required ({String postId, PostType postType}) super.argument,
  }) : super(
         retry: null,
         name: r'getSingleCurrentOrgPostStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getSingleCurrentOrgPostStreamHash();

  @override
  String toString() {
    return r'getSingleCurrentOrgPostStreamProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<PostModel?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<PostModel?> create(Ref ref) {
    final argument = this.argument as ({String postId, PostType postType});
    return getSingleCurrentOrgPostStream(
      ref,
      postId: argument.postId,
      postType: argument.postType,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<PostModel?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<PostModel?>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetSingleCurrentOrgPostStreamProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getSingleCurrentOrgPostStreamHash() =>
    r'fa01ec7ae746be8234c0cea97dc9b25253cfaeb4';

final class GetSingleCurrentOrgPostStreamFamily extends $Family
    with
        $FunctionalFamilyOverride<
          AsyncValue<PostModel?>,
          ({String postId, PostType postType})
        > {
  const GetSingleCurrentOrgPostStreamFamily._()
    : super(
        retry: null,
        name: r'getSingleCurrentOrgPostStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetSingleCurrentOrgPostStreamProvider call({
    required String postId,
    required PostType postType,
  }) => GetSingleCurrentOrgPostStreamProvider._(
    argument: (postId: postId, postType: postType),
    from: this,
  );

  @override
  String toString() => r'getSingleCurrentOrgPostStreamProvider';
}

@ProviderFor(getCurrentOrgFeedPostsStream)
const getCurrentOrgFeedPostsStreamProvider =
    GetCurrentOrgFeedPostsStreamProvider._();

final class GetCurrentOrgFeedPostsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PostModel>>,
          AsyncValue<List<PostModel>>,
          AsyncValue<List<PostModel>>
        >
    with $Provider<AsyncValue<List<PostModel>>> {
  const GetCurrentOrgFeedPostsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCurrentOrgFeedPostsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCurrentOrgFeedPostsStreamHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<PostModel>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<PostModel>> create(Ref ref) {
    return getCurrentOrgFeedPostsStream(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<PostModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<PostModel>>>(value),
    );
  }
}

String _$getCurrentOrgFeedPostsStreamHash() =>
    r'7b7f4245b147537534c32a0ca0b66577febcd3e9';

@ProviderFor(getCurrentOrgAboutPostsStream)
const getCurrentOrgAboutPostsStreamProvider =
    GetCurrentOrgAboutPostsStreamProvider._();

final class GetCurrentOrgAboutPostsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PostModel>>,
          AsyncValue<List<PostModel>>,
          AsyncValue<List<PostModel>>
        >
    with $Provider<AsyncValue<List<PostModel>>> {
  const GetCurrentOrgAboutPostsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCurrentOrgAboutPostsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCurrentOrgAboutPostsStreamHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<PostModel>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<PostModel>> create(Ref ref) {
    return getCurrentOrgAboutPostsStream(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<PostModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<PostModel>>>(value),
    );
  }
}

String _$getCurrentOrgAboutPostsStreamHash() =>
    r'5c257ac87bbb73239510e5fefe17745a8a0260a6';

@ProviderFor(PostActions)
const postActionsProvider = PostActionsProvider._();

final class PostActionsProvider extends $NotifierProvider<PostActions, void> {
  const PostActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postActionsHash();

  @$internal
  @override
  PostActions create() => PostActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$postActionsHash() => r'095ef61a3be23264bd42229b2936b1af355a4b56';

abstract class _$PostActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
