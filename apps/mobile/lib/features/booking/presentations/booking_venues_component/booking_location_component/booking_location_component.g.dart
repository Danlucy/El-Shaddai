// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_location_component.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(TargetNotifier)
const targetNotifierProvider = TargetNotifierProvider._();

final class TargetNotifierProvider
    extends $NotifierProvider<TargetNotifier, LatLng?> {
  const TargetNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'targetNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$targetNotifierHash();

  @$internal
  @override
  TargetNotifier create() => TargetNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LatLng? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LatLng?>(value),
    );
  }
}

String _$targetNotifierHash() => r'0fac9919eb756d1405edeb5083b50c0f515393b3';

abstract class _$TargetNotifier extends $Notifier<LatLng?> {
  LatLng? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LatLng?, LatLng?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<LatLng?, LatLng?>, LatLng?, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
