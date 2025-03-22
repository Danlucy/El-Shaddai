// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileControllerHash() => r'6dac475fbd71eac840230c8db1acf0268f89f459';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ProfileController
    extends BuildlessAutoDisposeStreamNotifier<Map<String, dynamic>> {
  late final String? uid;

  Stream<Map<String, dynamic>> build(
    String? uid,
  );
}

/// See also [ProfileController].
@ProviderFor(ProfileController)
const profileControllerProvider = ProfileControllerFamily();

/// See also [ProfileController].
class ProfileControllerFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [ProfileController].
  const ProfileControllerFamily();

  /// See also [ProfileController].
  ProfileControllerProvider call(
    String? uid,
  ) {
    return ProfileControllerProvider(
      uid,
    );
  }

  @override
  ProfileControllerProvider getProviderOverride(
    covariant ProfileControllerProvider provider,
  ) {
    return call(
      provider.uid,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'profileControllerProvider';
}

/// See also [ProfileController].
class ProfileControllerProvider extends AutoDisposeStreamNotifierProviderImpl<
    ProfileController, Map<String, dynamic>> {
  /// See also [ProfileController].
  ProfileControllerProvider(
    String? uid,
  ) : this._internal(
          () => ProfileController()..uid = uid,
          from: profileControllerProvider,
          name: r'profileControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$profileControllerHash,
          dependencies: ProfileControllerFamily._dependencies,
          allTransitiveDependencies:
              ProfileControllerFamily._allTransitiveDependencies,
          uid: uid,
        );

  ProfileControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String? uid;

  @override
  Stream<Map<String, dynamic>> runNotifierBuild(
    covariant ProfileController notifier,
  ) {
    return notifier.build(
      uid,
    );
  }

  @override
  Override overrideWith(ProfileController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProfileControllerProvider._internal(
        () => create()..uid = uid,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<ProfileController,
      Map<String, dynamic>> createElement() {
    return _ProfileControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfileControllerProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProfileControllerRef
    on AutoDisposeStreamNotifierProviderRef<Map<String, dynamic>> {
  /// The parameter `uid` of this provider.
  String? get uid;
}

class _ProfileControllerProviderElement
    extends AutoDisposeStreamNotifierProviderElement<ProfileController,
        Map<String, dynamic>> with ProfileControllerRef {
  _ProfileControllerProviderElement(super.provider);

  @override
  String? get uid => (origin as ProfileControllerProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
