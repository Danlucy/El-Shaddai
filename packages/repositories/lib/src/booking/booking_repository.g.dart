// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(bookingStream)
const bookingStreamProvider = BookingStreamFamily._();

final class BookingStreamProvider
    extends $FunctionalProvider<AsyncValue<dynamic>, dynamic, Stream<dynamic>>
    with $FutureModifier<dynamic>, $StreamProvider<dynamic> {
  const BookingStreamProvider._(
      {required BookingStreamFamily super.from,
      required String? super.argument})
      : super(
          retry: null,
          name: r'bookingStreamProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$bookingStreamHash();

  @override
  String toString() {
    return r'bookingStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<dynamic> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<dynamic> create(Ref ref) {
    final argument = this.argument as String?;
    return bookingStream(
      ref,
      bookingId: argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BookingStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookingStreamHash() => r'9908978df0afcd8b4db74214ec562a9f262ed521';

final class BookingStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<dynamic>, String?> {
  const BookingStreamFamily._()
      : super(
          retry: null,
          name: r'bookingStreamProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  BookingStreamProvider call({
    String? bookingId,
  }) =>
      BookingStreamProvider._(argument: bookingId, from: this);

  @override
  String toString() => r'bookingStreamProvider';
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
