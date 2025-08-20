// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(PostController)
const postControllerProvider = PostControllerProvider._();

final class PostControllerProvider
    extends $NotifierProvider<PostController, PostState> {
  const PostControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'postControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$postControllerHash();

  @$internal
  @override
  PostController create() => PostController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostState>(value),
    );
  }
}

String _$postControllerHash() => r'3f1398eb34148fbd54bcfafb1ed99a6d34d2580c';

abstract class _$PostController extends $Notifier<PostState> {
  PostState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PostState, PostState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<PostState, PostState>, PostState, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
