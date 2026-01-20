// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_management_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// ✅ **Provider for UserManagementRepository**
@ProviderFor(userManagementRepository)
const userManagementRepositoryProvider = UserManagementRepositoryFamily._();

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
  const UserManagementRepositoryProvider._({
    required UserManagementRepositoryFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'userManagementRepositoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userManagementRepositoryHash();

  @override
  String toString() {
    return r'userManagementRepositoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<UserManagementRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UserManagementRepository create(Ref ref) {
    final argument = this.argument as String?;
    return userManagementRepository(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserManagementRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserManagementRepository>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserManagementRepositoryProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userManagementRepositoryHash() =>
    r'8410e94a0b067e05d83723c03b5cfda7417abaa8';

/// ✅ **Provider for UserManagementRepository**
final class UserManagementRepositoryFamily extends $Family
    with $FunctionalFamilyOverride<UserManagementRepository, String?> {
  const UserManagementRepositoryFamily._()
    : super(
        retry: null,
        name: r'userManagementRepositoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// ✅ **Provider for UserManagementRepository**
  UserManagementRepositoryProvider call(String? organizationId) =>
      UserManagementRepositoryProvider._(argument: organizationId, from: this);

  @override
  String toString() => r'userManagementRepositoryProvider';
}

@ProviderFor(usersByRoleForOrg)
const usersByRoleForOrgProvider = UsersByRoleForOrgFamily._();

final class UsersByRoleForOrgProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserModel>>,
          List<UserModel>,
          Stream<List<UserModel>>
        >
    with $FutureModifier<List<UserModel>>, $StreamProvider<List<UserModel>> {
  const UsersByRoleForOrgProvider._({
    required UsersByRoleForOrgFamily super.from,
    required ({String orgId, UserRole? role, String searchTerm}) super.argument,
  }) : super(
         retry: null,
         name: r'usersByRoleForOrgProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$usersByRoleForOrgHash();

  @override
  String toString() {
    return r'usersByRoleForOrgProvider'
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
    final argument =
        this.argument as ({String orgId, UserRole? role, String searchTerm});
    return usersByRoleForOrg(
      ref,
      orgId: argument.orgId,
      role: argument.role,
      searchTerm: argument.searchTerm,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UsersByRoleForOrgProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$usersByRoleForOrgHash() => r'34dc57a3c9c5eb125cea09e9eda254930297b309';

final class UsersByRoleForOrgFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<List<UserModel>>,
          ({String orgId, UserRole? role, String searchTerm})
        > {
  const UsersByRoleForOrgFamily._()
    : super(
        retry: null,
        name: r'usersByRoleForOrgProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UsersByRoleForOrgProvider call({
    required String orgId,
    UserRole? role,
    String searchTerm = '',
  }) => UsersByRoleForOrgProvider._(
    argument: (orgId: orgId, role: role, searchTerm: searchTerm),
    from: this,
  );

  @override
  String toString() => r'usersByRoleForOrgProvider';
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
