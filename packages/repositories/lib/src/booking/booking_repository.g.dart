// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(currentOrgBookingsStream)
const currentOrgBookingsStreamProvider = CurrentOrgBookingsStreamFamily._();

final class CurrentOrgBookingsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BookingModel>>,
          List<BookingModel>,
          Stream<List<BookingModel>>
        >
    with
        $FutureModifier<List<BookingModel>>,
        $StreamProvider<List<BookingModel>> {
  const CurrentOrgBookingsStreamProvider._({
    required CurrentOrgBookingsStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'currentOrgBookingsStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$currentOrgBookingsStreamHash();

  @override
  String toString() {
    return r'currentOrgBookingsStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<BookingModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<BookingModel>> create(Ref ref) {
    final argument = this.argument as String;
    return currentOrgBookingsStream(ref, organizationId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentOrgBookingsStreamProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$currentOrgBookingsStreamHash() =>
    r'd84baeb0b978ccf761ea003769cf237d150ef45a';

final class CurrentOrgBookingsStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<BookingModel>>, String> {
  const CurrentOrgBookingsStreamFamily._()
    : super(
        retry: null,
        name: r'currentOrgBookingsStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CurrentOrgBookingsStreamProvider call({required String organizationId}) =>
      CurrentOrgBookingsStreamProvider._(argument: organizationId, from: this);

  @override
  String toString() => r'currentOrgBookingsStreamProvider';
}

@ProviderFor(singleCurrentOrgBookingStream)
const singleCurrentOrgBookingStreamProvider =
    SingleCurrentOrgBookingStreamFamily._();

final class SingleCurrentOrgBookingStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<BookingModel?>,
          BookingModel?,
          Stream<BookingModel?>
        >
    with $FutureModifier<BookingModel?>, $StreamProvider<BookingModel?> {
  const SingleCurrentOrgBookingStreamProvider._({
    required SingleCurrentOrgBookingStreamFamily super.from,
    required ({String organizationId, String bookingId}) super.argument,
  }) : super(
         retry: null,
         name: r'singleCurrentOrgBookingStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$singleCurrentOrgBookingStreamHash();

  @override
  String toString() {
    return r'singleCurrentOrgBookingStreamProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<BookingModel?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<BookingModel?> create(Ref ref) {
    final argument =
        this.argument as ({String organizationId, String bookingId});
    return singleCurrentOrgBookingStream(
      ref,
      organizationId: argument.organizationId,
      bookingId: argument.bookingId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SingleCurrentOrgBookingStreamProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$singleCurrentOrgBookingStreamHash() =>
    r'be1a4d6269fc368f7a014865e92edc907d26263b';

final class SingleCurrentOrgBookingStreamFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<BookingModel?>,
          ({String organizationId, String bookingId})
        > {
  const SingleCurrentOrgBookingStreamFamily._()
    : super(
        retry: null,
        name: r'singleCurrentOrgBookingStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SingleCurrentOrgBookingStreamProvider call({
    required String organizationId,
    required String bookingId,
  }) => SingleCurrentOrgBookingStreamProvider._(
    argument: (organizationId: organizationId, bookingId: bookingId),
    from: this,
  );

  @override
  String toString() => r'singleCurrentOrgBookingStreamProvider';
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
