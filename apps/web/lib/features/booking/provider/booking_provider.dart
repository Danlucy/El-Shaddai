import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_provider.g.dart';

final currentOrgRepositoryProvider = Provider<BookingRepository>((ref) {
  // 1. Watch the current organization from your mobile app
  final currentOrg = ref.watch(organizationControllerProvider);

  // 2. Handle the AsyncValue state from organizationControllerProvider
  return currentOrg.when(
    // When organization is loaded successfully
    data: (orgId) => ref.watch(bookingRepositoryProvider(orgId.name)),

    // When organization is still loading
    loading: () => throw StateError('Organization not loaded'),

    // When there's an error loading organization
    error: (err, stack) => throw err,
  );
});

@riverpod
AsyncValue<List<BookingModel>> getCurrentOrgBookingsStream(Ref ref) {
  final orgAsync = ref.watch(organizationControllerProvider);

  return orgAsync.when(
    data: (org) =>
        ref.watch(currentOrgBookingsStreamProvider(organizationId: org.name)),
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
}

@riverpod
AsyncValue<BookingModel?> getSingleCurrentOrgBookingStream(
  Ref ref, {
  required String bookingId,
}) {
  final orgAsync = ref.watch(organizationControllerProvider);
  return orgAsync.when(
    data: (org) => ref.watch(
      singleCurrentOrgBookingStreamProvider(
        organizationId: org.name,
        bookingId: bookingId,
      ),
    ),
    loading: () => AsyncLoading(),
    error: (err, stack) => AsyncError(err, stack),
  );
}
