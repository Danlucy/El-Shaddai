// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(SelectedBookingIDNotifier)
const selectedBookingIDNotifierProvider = SelectedBookingIDNotifierProvider._();

final class SelectedBookingIDNotifierProvider
    extends $NotifierProvider<SelectedBookingIDNotifier, String> {
  const SelectedBookingIDNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedBookingIDNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedBookingIDNotifierHash();

  @$internal
  @override
  SelectedBookingIDNotifier create() => SelectedBookingIDNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$selectedBookingIDNotifierHash() =>
    r'538d82f82b3337b8a01e113e4e67c0e134859b6a';

abstract class _$SelectedBookingIDNotifier extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
