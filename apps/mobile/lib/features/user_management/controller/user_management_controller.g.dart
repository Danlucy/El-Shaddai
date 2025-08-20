// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_management_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(UserManagementController)
const userManagementControllerProvider = UserManagementControllerProvider._();

final class UserManagementControllerProvider
    extends $NotifierProvider<UserManagementController, void> {
  const UserManagementControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'userManagementControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userManagementControllerHash();

  @$internal
  @override
  UserManagementController create() => UserManagementController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$userManagementControllerHash() =>
    r'bcbf1ec9a2e1ae89a5161264dbf184cabfb3172c';

abstract class _$UserManagementController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<void, void>, void, Object?, Object?>;
    element.handleValue(ref, null);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
