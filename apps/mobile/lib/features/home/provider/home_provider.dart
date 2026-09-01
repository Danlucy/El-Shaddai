import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repositories/repositories.dart';

final currentOrgHomeTextProvider = Provider<AsyncValue<String?>>((ref) {
  final organization = ref.watch(organizationControllerProvider);

  return organization.when(
    data: (organization) =>
        ref.watch(homeTextStreamProvider(organization.name)),
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});
