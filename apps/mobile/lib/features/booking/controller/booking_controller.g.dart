// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(BookingVenueState)
const bookingVenueStateProvider = BookingVenueStateProvider._();

final class BookingVenueStateProvider
    extends $NotifierProvider<BookingVenueState, BookingVenueComponent> {
  const BookingVenueStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingVenueStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingVenueStateHash();

  @$internal
  @override
  BookingVenueState create() => BookingVenueState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingVenueComponent value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingVenueComponent>(value),
    );
  }
}

String _$bookingVenueStateHash() => r'd26781d813c1dd924bc2e9c7ceff55be49af57ed';

abstract class _$BookingVenueState extends $Notifier<BookingVenueComponent> {
  BookingVenueComponent build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BookingVenueComponent, BookingVenueComponent>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BookingVenueComponent, BookingVenueComponent>,
              BookingVenueComponent,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(BookingController)
const bookingControllerProvider = BookingControllerProvider._();

final class BookingControllerProvider
    extends $NotifierProvider<BookingController, BookingState> {
  const BookingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingControllerHash();

  @$internal
  @override
  BookingController create() => BookingController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingState>(value),
    );
  }
}

String _$bookingControllerHash() => r'fdb7b88d9cca18ca8fa26d02e6900134156f3e1a';

abstract class _$BookingController extends $Notifier<BookingState> {
  BookingState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BookingState, BookingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BookingState, BookingState>,
              BookingState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
