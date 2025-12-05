// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(ParticipantController)
const participantControllerProvider = ParticipantControllerFamily._();

final class ParticipantControllerProvider
    extends $NotifierProvider<ParticipantController, ParticipantState> {
  const ParticipantControllerProvider._({
    required ParticipantControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'participantControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$participantControllerHash();

  @override
  String toString() {
    return r'participantControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ParticipantController create() => ParticipantController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ParticipantState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ParticipantState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ParticipantControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$participantControllerHash() =>
    r'883eb57be4c57f9f66f4e9c4d056642db4df8294';

final class ParticipantControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ParticipantController,
          ParticipantState,
          ParticipantState,
          ParticipantState,
          String
        > {
  const ParticipantControllerFamily._()
    : super(
        retry: null,
        name: r'participantControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ParticipantControllerProvider call(String bookingId) =>
      ParticipantControllerProvider._(argument: bookingId, from: this);

  @override
  String toString() => r'participantControllerProvider';
}

abstract class _$ParticipantController extends $Notifier<ParticipantState> {
  late final _$args = ref.$arg as String;
  String get bookingId => _$args;

  ParticipantState build(String bookingId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<ParticipantState, ParticipantState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ParticipantState, ParticipantState>,
              ParticipantState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
