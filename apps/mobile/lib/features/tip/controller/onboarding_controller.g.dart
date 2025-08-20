// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(OnboardingNotifier)
const onboardingNotifierProvider = OnboardingNotifierProvider._();

final class OnboardingNotifierProvider
    extends $AsyncNotifierProvider<OnboardingNotifier, Set<String>> {
  const OnboardingNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'onboardingNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$onboardingNotifierHash();

  @$internal
  @override
  OnboardingNotifier create() => OnboardingNotifier();
}

String _$onboardingNotifierHash() =>
    r'545d647bf5e3de77bcd241043a9c9c83b2e433de';

abstract class _$OnboardingNotifier extends $AsyncNotifier<Set<String>> {
  FutureOr<Set<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Set<String>>, Set<String>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Set<String>>, Set<String>>,
        AsyncValue<Set<String>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
