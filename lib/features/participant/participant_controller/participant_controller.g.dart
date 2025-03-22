// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$participantControllerHash() =>
    r'8f8049ed0049874ded092536cdaa2faf9259bc14';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ParticipantController
    extends BuildlessAutoDisposeNotifier<ParticipantState> {
  late final String bookingId;

  ParticipantState build(
    String bookingId,
  );
}

/// See also [ParticipantController].
@ProviderFor(ParticipantController)
const participantControllerProvider = ParticipantControllerFamily();

/// See also [ParticipantController].
class ParticipantControllerFamily extends Family<ParticipantState> {
  /// See also [ParticipantController].
  const ParticipantControllerFamily();

  /// See also [ParticipantController].
  ParticipantControllerProvider call(
    String bookingId,
  ) {
    return ParticipantControllerProvider(
      bookingId,
    );
  }

  @override
  ParticipantControllerProvider getProviderOverride(
    covariant ParticipantControllerProvider provider,
  ) {
    return call(
      provider.bookingId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'participantControllerProvider';
}

/// See also [ParticipantController].
class ParticipantControllerProvider extends AutoDisposeNotifierProviderImpl<
    ParticipantController, ParticipantState> {
  /// See also [ParticipantController].
  ParticipantControllerProvider(
    String bookingId,
  ) : this._internal(
          () => ParticipantController()..bookingId = bookingId,
          from: participantControllerProvider,
          name: r'participantControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$participantControllerHash,
          dependencies: ParticipantControllerFamily._dependencies,
          allTransitiveDependencies:
              ParticipantControllerFamily._allTransitiveDependencies,
          bookingId: bookingId,
        );

  ParticipantControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookingId,
  }) : super.internal();

  final String bookingId;

  @override
  ParticipantState runNotifierBuild(
    covariant ParticipantController notifier,
  ) {
    return notifier.build(
      bookingId,
    );
  }

  @override
  Override overrideWith(ParticipantController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ParticipantControllerProvider._internal(
        () => create()..bookingId = bookingId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookingId: bookingId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ParticipantController, ParticipantState>
      createElement() {
    return _ParticipantControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ParticipantControllerProvider &&
        other.bookingId == bookingId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookingId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ParticipantControllerRef
    on AutoDisposeNotifierProviderRef<ParticipantState> {
  /// The parameter `bookingId` of this provider.
  String get bookingId;
}

class _ParticipantControllerProviderElement
    extends AutoDisposeNotifierProviderElement<ParticipantController,
        ParticipantState> with ParticipantControllerRef {
  _ParticipantControllerProviderElement(super.provider);

  @override
  String get bookingId => (origin as ParticipantControllerProvider).bookingId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
