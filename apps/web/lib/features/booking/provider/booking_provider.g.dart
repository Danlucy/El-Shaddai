// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(getCurrentOrgBookingsStream)
const getCurrentOrgBookingsStreamProvider =
    GetCurrentOrgBookingsStreamProvider._();

final class GetCurrentOrgBookingsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BookingModel>>,
          AsyncValue<List<BookingModel>>,
          AsyncValue<List<BookingModel>>
        >
    with $Provider<AsyncValue<List<BookingModel>>> {
  const GetCurrentOrgBookingsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCurrentOrgBookingsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCurrentOrgBookingsStreamHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<BookingModel>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<BookingModel>> create(Ref ref) {
    return getCurrentOrgBookingsStream(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<BookingModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<BookingModel>>>(
        value,
      ),
    );
  }
}

String _$getCurrentOrgBookingsStreamHash() =>
    r'600bba250611ab0cdfede82804453ec873ef0b59';

@ProviderFor(BookingListSearchQuery)
const bookingListSearchQueryProvider = BookingListSearchQueryProvider._();

final class BookingListSearchQueryProvider
    extends $NotifierProvider<BookingListSearchQuery, String> {
  const BookingListSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingListSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingListSearchQueryHash();

  @$internal
  @override
  BookingListSearchQuery create() => BookingListSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$bookingListSearchQueryHash() =>
    r'e0e7e4e623ef8032926bbca57c1a1f1d54b0a411';

abstract class _$BookingListSearchQuery extends $Notifier<String> {
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

@ProviderFor(filteredBookingLists)
const filteredBookingListsProvider = FilteredBookingListsProvider._();

final class FilteredBookingListsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BookingModel>>,
          AsyncValue<List<BookingModel>>,
          AsyncValue<List<BookingModel>>
        >
    with $Provider<AsyncValue<List<BookingModel>>> {
  const FilteredBookingListsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredBookingListsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredBookingListsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<BookingModel>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<BookingModel>> create(Ref ref) {
    return filteredBookingLists(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<BookingModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<BookingModel>>>(
        value,
      ),
    );
  }
}

String _$filteredBookingListsHash() =>
    r'091a337469b792f32850be55a4451b1cd3887859';

@ProviderFor(getSingleCurrentOrgBookingStream)
const getSingleCurrentOrgBookingStreamProvider =
    GetSingleCurrentOrgBookingStreamFamily._();

final class GetSingleCurrentOrgBookingStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<BookingModel?>,
          AsyncValue<BookingModel?>,
          AsyncValue<BookingModel?>
        >
    with $Provider<AsyncValue<BookingModel?>> {
  const GetSingleCurrentOrgBookingStreamProvider._({
    required GetSingleCurrentOrgBookingStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getSingleCurrentOrgBookingStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getSingleCurrentOrgBookingStreamHash();

  @override
  String toString() {
    return r'getSingleCurrentOrgBookingStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<BookingModel?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<BookingModel?> create(Ref ref) {
    final argument = this.argument as String;
    return getSingleCurrentOrgBookingStream(ref, bookingId: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<BookingModel?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<BookingModel?>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetSingleCurrentOrgBookingStreamProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getSingleCurrentOrgBookingStreamHash() =>
    r'9ac0129f3462e4fa80cb1d359ac79cd5b03ddbff';

final class GetSingleCurrentOrgBookingStreamFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<BookingModel?>, String> {
  const GetSingleCurrentOrgBookingStreamFamily._()
    : super(
        retry: null,
        name: r'getSingleCurrentOrgBookingStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetSingleCurrentOrgBookingStreamProvider call({required String bookingId}) =>
      GetSingleCurrentOrgBookingStreamProvider._(
        argument: bookingId,
        from: this,
      );

  @override
  String toString() => r'getSingleCurrentOrgBookingStreamProvider';
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
