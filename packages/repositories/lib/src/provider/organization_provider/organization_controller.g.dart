// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(OrganizationController)
const organizationControllerProvider = OrganizationControllerProvider._();

final class OrganizationControllerProvider
    extends $AsyncNotifierProvider<OrganizationController, OrganizationsID> {
  const OrganizationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'organizationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$organizationControllerHash();

  @$internal
  @override
  OrganizationController create() => OrganizationController();
}

String _$organizationControllerHash() =>
    r'409d06e6511403fdfcb241f3a10ea03b90c7c4c4';

abstract class _$OrganizationController
    extends $AsyncNotifier<OrganizationsID> {
  FutureOr<OrganizationsID> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<OrganizationsID>, OrganizationsID>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<OrganizationsID>, OrganizationsID>,
              AsyncValue<OrganizationsID>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
