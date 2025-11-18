// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_management_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(usersByRole)
const usersByRoleProvider = UsersByRoleFamily._();

final class UsersByRoleProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserModel>>,
          AsyncValue<List<UserModel>>,
          AsyncValue<List<UserModel>>
        >
    with $Provider<AsyncValue<List<UserModel>>> {
  const UsersByRoleProvider._({
    required UsersByRoleFamily super.from,
    required ({UserRole? role, String searchTerm}) super.argument,
  }) : super(
         retry: null,
         name: r'usersByRoleProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$usersByRoleHash();

  @override
  String toString() {
    return r'usersByRoleProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<List<UserModel>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<UserModel>> create(Ref ref) {
    final argument = this.argument as ({UserRole? role, String searchTerm});
    return usersByRole(
      ref,
      role: argument.role,
      searchTerm: argument.searchTerm,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<UserModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<UserModel>>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UsersByRoleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$usersByRoleHash() => r'6d40808580bcdca2232e2fb8b3b8302af8f2532b';

final class UsersByRoleFamily extends $Family
    with
        $FunctionalFamilyOverride<
          AsyncValue<List<UserModel>>,
          ({UserRole? role, String searchTerm})
        > {
  const UsersByRoleFamily._()
    : super(
        retry: null,
        name: r'usersByRoleProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UsersByRoleProvider call({UserRole? role, String searchTerm = ''}) =>
      UsersByRoleProvider._(
        argument: (role: role, searchTerm: searchTerm),
        from: this,
      );

  @override
  String toString() => r'usersByRoleProvider';
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
