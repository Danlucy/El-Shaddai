// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookingStreamHash() => r'5ee608d3f3504ca4f45ccde58e88feaadfcd1b7a';

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

/// See also [bookingStream].
@ProviderFor(bookingStream)
const bookingStreamProvider = BookingStreamFamily();

/// See also [bookingStream].
class BookingStreamFamily extends Family<AsyncValue<dynamic>> {
  /// See also [bookingStream].
  const BookingStreamFamily();

  /// See also [bookingStream].
  BookingStreamProvider call({
    String? bookingId,
  }) {
    return BookingStreamProvider(
      bookingId: bookingId,
    );
  }

  @override
  BookingStreamProvider getProviderOverride(
    covariant BookingStreamProvider provider,
  ) {
    return call(
      bookingId: provider.bookingId,
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
  String? get name => r'bookingStreamProvider';
}

/// See also [bookingStream].
class BookingStreamProvider extends AutoDisposeStreamProvider<dynamic> {
  /// See also [bookingStream].
  BookingStreamProvider({
    String? bookingId,
  }) : this._internal(
          (ref) => bookingStream(
            ref as BookingStreamRef,
            bookingId: bookingId,
          ),
          from: bookingStreamProvider,
          name: r'bookingStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookingStreamHash,
          dependencies: BookingStreamFamily._dependencies,
          allTransitiveDependencies:
              BookingStreamFamily._allTransitiveDependencies,
          bookingId: bookingId,
        );

  BookingStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookingId,
  }) : super.internal();

  final String? bookingId;

  @override
  Override overrideWith(
    Stream<dynamic> Function(BookingStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BookingStreamProvider._internal(
        (ref) => create(ref as BookingStreamRef),
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
  AutoDisposeStreamProviderElement<dynamic> createElement() {
    return _BookingStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookingStreamProvider && other.bookingId == bookingId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookingId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BookingStreamRef on AutoDisposeStreamProviderRef<dynamic> {
  /// The parameter `bookingId` of this provider.
  String? get bookingId;
}

class _BookingStreamProviderElement
    extends AutoDisposeStreamProviderElement<dynamic> with BookingStreamRef {
  _BookingStreamProviderElement(super.provider);

  @override
  String? get bookingId => (origin as BookingStreamProvider).bookingId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
