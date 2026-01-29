// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(ProfileController)
const profileControllerProvider = ProfileControllerFamily._();

final class ProfileControllerProvider
    extends $StreamNotifierProvider<ProfileController, Map<String, dynamic>> {
  const ProfileControllerProvider._({
    required ProfileControllerFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'profileControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$profileControllerHash();

  @override
  String toString() {
    return r'profileControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProfileController create() => ProfileController();

  @override
  bool operator ==(Object other) {
    return other is ProfileControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$profileControllerHash() => r'003d3ea048889e77a03d5ab65b4220c9ba58d8d5';

final class ProfileControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ProfileController,
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          Stream<Map<String, dynamic>>,
          String?
        > {
  const ProfileControllerFamily._()
    : super(
        retry: null,
        name: r'profileControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProfileControllerProvider call(String? uid) =>
      ProfileControllerProvider._(argument: uid, from: this);

  @override
  String toString() => r'profileControllerProvider';
}

abstract class _$ProfileController
    extends $StreamNotifier<Map<String, dynamic>> {
  late final _$args = ref.$arg as String?;
  String? get uid => _$args;

  Stream<Map<String, dynamic>> build(String? uid);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref
            as $Ref<AsyncValue<Map<String, dynamic>>, Map<String, dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<String, dynamic>>,
                Map<String, dynamic>
              >,
              AsyncValue<Map<String, dynamic>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
