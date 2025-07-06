// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccessTokenImpl _$$AccessTokenImplFromJson(Map<String, dynamic> json) =>
    _$AccessTokenImpl(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      duration: DateTime.parse(json['duration'] as String),
    );

Map<String, dynamic> _$$AccessTokenImplToJson(_$AccessTokenImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'duration': instance.duration.toIso8601String(),
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accessTokenNotifierHash() =>
    r'dd3aa02600f03597dea14a8c67379f23e1ed7421';

/// See also [AccessTokenNotifier].
@ProviderFor(AccessTokenNotifier)
final accessTokenNotifierProvider = AutoDisposeAsyncNotifierProvider<
    AccessTokenNotifier, AccessToken?>.internal(
  AccessTokenNotifier.new,
  name: r'accessTokenNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accessTokenNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AccessTokenNotifier = AutoDisposeAsyncNotifier<AccessToken?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
