// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zoom_auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(AuthTokenNotifier)
const authTokenNotifierProvider = AuthTokenNotifierProvider._();

final class AuthTokenNotifierProvider
    extends $NotifierProvider<AuthTokenNotifier, String?> {
  const AuthTokenNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authTokenNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authTokenNotifierHash();

  @$internal
  @override
  AuthTokenNotifier create() => AuthTokenNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$authTokenNotifierHash() => r'1a31d8f70e192ccdc4e827b72bbbd9d7ad32f211';

abstract class _$AuthTokenNotifier extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
