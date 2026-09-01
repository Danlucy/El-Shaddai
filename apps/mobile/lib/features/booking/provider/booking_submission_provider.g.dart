// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_submission_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(BookingSubmissionNotifier)
const bookingSubmissionNotifierProvider = BookingSubmissionNotifierProvider._();

final class BookingSubmissionNotifierProvider
    extends
        $NotifierProvider<BookingSubmissionNotifier, BookingSubmissionState> {
  const BookingSubmissionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingSubmissionNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingSubmissionNotifierHash();

  @$internal
  @override
  BookingSubmissionNotifier create() => BookingSubmissionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingSubmissionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingSubmissionState>(value),
    );
  }
}

String _$bookingSubmissionNotifierHash() =>
    r'bb41d177cc4e449b44bf7400ce458fbc1eb83167';

abstract class _$BookingSubmissionNotifier
    extends $Notifier<BookingSubmissionState> {
  BookingSubmissionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<BookingSubmissionState, BookingSubmissionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BookingSubmissionState, BookingSubmissionState>,
              BookingSubmissionState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
