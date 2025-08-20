// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccessToken _$AccessTokenFromJson(Map<String, dynamic> json) => _AccessToken(
  token: json['token'] as String,
  refreshToken: json['refreshToken'] as String,
  duration: DateTime.parse(json['duration'] as String),
);

Map<String, dynamic> _$AccessTokenToJson(_AccessToken instance) =>
    <String, dynamic>{
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'duration': instance.duration.toIso8601String(),
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(AccessTokenNotifier)
const accessTokenNotifierProvider = AccessTokenNotifierProvider._();

final class AccessTokenNotifierProvider
    extends $AsyncNotifierProvider<AccessTokenNotifier, AccessToken?> {
  const AccessTokenNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accessTokenNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accessTokenNotifierHash();

  @$internal
  @override
  AccessTokenNotifier create() => AccessTokenNotifier();
}

String _$accessTokenNotifierHash() =>
    r'dd3aa02600f03597dea14a8c67379f23e1ed7421';

abstract class _$AccessTokenNotifier extends $AsyncNotifier<AccessToken?> {
  FutureOr<AccessToken?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<AccessToken?>, AccessToken?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AccessToken?>, AccessToken?>,
              AsyncValue<AccessToken?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
