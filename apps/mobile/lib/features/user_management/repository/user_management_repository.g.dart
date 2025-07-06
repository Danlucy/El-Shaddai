// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_management_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userManagementRepositoryHash() =>
    r'26d6a8ac566e5dfea6b565bec3e8caa7a14327c2';

/// ✅ **Provider for UserManagementRepository**
///
/// Copied from [userManagementRepository].
@ProviderFor(userManagementRepository)
final userManagementRepositoryProvider =
    AutoDisposeProvider<UserManagementRepository>.internal(
  userManagementRepository,
  name: r'userManagementRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userManagementRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserManagementRepositoryRef
    = AutoDisposeProviderRef<UserManagementRepository>;
String _$usersByRoleHash() => r'6ff116dc9f46757f6dab8051c4cf5afc27389558';

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

/// See also [usersByRole].
@ProviderFor(usersByRole)
const usersByRoleProvider = UsersByRoleFamily();

/// See also [usersByRole].
class UsersByRoleFamily extends Family<AsyncValue<List<UserModel>>> {
  /// See also [usersByRole].
  const UsersByRoleFamily();

  /// See also [usersByRole].
  UsersByRoleProvider call({
    String searchTerm = '',
  }) {
    return UsersByRoleProvider(
      searchTerm: searchTerm,
    );
  }

  @override
  UsersByRoleProvider getProviderOverride(
    covariant UsersByRoleProvider provider,
  ) {
    return call(
      searchTerm: provider.searchTerm,
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
  String? get name => r'usersByRoleProvider';
}

/// See also [usersByRole].
class UsersByRoleProvider extends AutoDisposeStreamProvider<List<UserModel>> {
  /// See also [usersByRole].
  UsersByRoleProvider({
    String searchTerm = '',
  }) : this._internal(
          (ref) => usersByRole(
            ref as UsersByRoleRef,
            searchTerm: searchTerm,
          ),
          from: usersByRoleProvider,
          name: r'usersByRoleProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$usersByRoleHash,
          dependencies: UsersByRoleFamily._dependencies,
          allTransitiveDependencies:
              UsersByRoleFamily._allTransitiveDependencies,
          searchTerm: searchTerm,
        );

  UsersByRoleProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.searchTerm,
  }) : super.internal();

  final String searchTerm;

  @override
  Override overrideWith(
    Stream<List<UserModel>> Function(UsersByRoleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UsersByRoleProvider._internal(
        (ref) => create(ref as UsersByRoleRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        searchTerm: searchTerm,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<UserModel>> createElement() {
    return _UsersByRoleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UsersByRoleProvider && other.searchTerm == searchTerm;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchTerm.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UsersByRoleRef on AutoDisposeStreamProviderRef<List<UserModel>> {
  /// The parameter `searchTerm` of this provider.
  String get searchTerm;
}

class _UsersByRoleProviderElement
    extends AutoDisposeStreamProviderElement<List<UserModel>>
    with UsersByRoleRef {
  _UsersByRoleProviderElement(super.provider);

  @override
  String get searchTerm => (origin as UsersByRoleProvider).searchTerm;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
