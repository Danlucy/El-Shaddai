// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(CalendarDateNotifier)
const calendarDateNotifierProvider = CalendarDateNotifierProvider._();

final class CalendarDateNotifierProvider
    extends $NotifierProvider<CalendarDateNotifier, DateTime> {
  const CalendarDateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calendarDateNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calendarDateNotifierHash();

  @$internal
  @override
  CalendarDateNotifier create() => CalendarDateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$calendarDateNotifierHash() =>
    r'051cb791fa0ece89fc102d095dc0f811f42d5528';

abstract class _$CalendarDateNotifier extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
