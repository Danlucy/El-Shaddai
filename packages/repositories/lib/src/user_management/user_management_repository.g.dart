// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_management_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// ✅ **Provider for UserManagementRepository**
@ProviderFor(userManagementRepository)
const userManagementRepositoryProvider = UserManagementRepositoryProvider._();

/// ✅ **Provider for UserManagementRepository**
final class UserManagementRepositoryProvider
    extends
        $FunctionalProvider<
          UserManagementRepository,
          UserManagementRepository,
          UserManagementRepository
        >
    with $Provider<UserManagementRepository> {
  /// ✅ **Provider for UserManagementRepository**
  const UserManagementRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userManagementRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userManagementRepositoryHash();

  @$internal
  @override
  $ProviderElement<UserManagementRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UserManagementRepository create(Ref ref) {
    return userManagementRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserManagementRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserManagementRepository>(value),
    );
  }
}

String _$userManagementRepositoryHash() =>
    r'26d6a8ac566e5dfea6b565bec3e8caa7a14327c2';

@ProviderFor(usersByRole)
const usersByRoleProvider = UsersByRoleFamily._();

final class UsersByRoleProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserModel>>,
          List<UserModel>,
          Stream<List<UserModel>>
        >
    with $FutureModifier<List<UserModel>>, $StreamProvider<List<UserModel>> {
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
  $StreamProviderElement<List<UserModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<UserModel>> create(Ref ref) {
    final argument = this.argument as ({UserRole? role, String searchTerm});
    return usersByRole(
      ref,
      role: argument.role,
      searchTerm: argument.searchTerm,
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

String _$usersByRoleHash() => r'ec53fa25fe1ba0ca263918824a4591966f526aea';

final class UsersByRoleFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<List<UserModel>>,
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
