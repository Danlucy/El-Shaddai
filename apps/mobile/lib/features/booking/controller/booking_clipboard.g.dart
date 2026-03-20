// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_clipboard.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(BookingClipboard)
const bookingClipboardProvider = BookingClipboardProvider._();

final class BookingClipboardProvider
    extends $NotifierProvider<BookingClipboard, BookingState?> {
  const BookingClipboardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingClipboardProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingClipboardHash();

  @$internal
  @override
  BookingClipboard create() => BookingClipboard();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingState? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingState?>(value),
    );
  }
}

String _$bookingClipboardHash() => r'2c93db3f0d1e6849f840841a4bf7c250b21ad8f8';

abstract class _$BookingClipboard extends $Notifier<BookingState?> {
  BookingState? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BookingState?, BookingState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BookingState?, BookingState?>,
              BookingState?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
