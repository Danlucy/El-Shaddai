// lib/providers/onboarding_controller.dart
import 'package:mobile/features/tip/controller/tip_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_controller.g.dart';

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  static const String _seenTipsKey = 'seen_onboarding_tips';

  // Make this async and return AsyncValue<Set<String>>
  @override
  Future<Set<String>> build() async {
    // Load the seen tips during build
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final seenTips = prefs.getStringList(_seenTipsKey) ?? [];
    return seenTips.toSet();
  }

  // Check if a specific tip has been seen
  bool hasSeenTip(String tipId) {
    return state.when(
      data: (tips) => tips.contains(tipId),
      loading: () => false,
      error: (_, __) => false,
    );
  }

  // Mark a tip as seen and save it to SharedPreferences
  Future<void> markTipAsSeen(String tipId) async {
    final currentTips = await future; // Wait for current state

    if (!currentTips.contains(tipId)) {
      final newSeenTips = {...currentTips, tipId};
      state = AsyncValue.data(newSeenTips);

      final prefs = await ref.read(sharedPreferencesProvider.future);
      await prefs.setStringList(_seenTipsKey, newSeenTips.toList());
    }
  }

  // Reset a specific tip
  Future<void> resetTip(String tipId) async {
    final currentTips = await future;

    if (currentTips.contains(tipId)) {
      final newSeenTips = {...currentTips};
      newSeenTips.remove(tipId);
      state = AsyncValue.data(newSeenTips);

      final prefs = await ref.read(sharedPreferencesProvider.future);
      await prefs.setStringList(_seenTipsKey, newSeenTips.toList());
    }
  }

  // Reset all tips
  Future<void> resetAllTips() async {
    state = const AsyncValue.data(<String>{});
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.remove(_seenTipsKey);
  }

  // Reset only zoom-related tips
  Future<void> resetZoomTips() async {
    final zoomTipIds = [
      'zoom_input_tour_tip',
      // Add other zoom-related tip IDs here
    ];

    final currentTips = await future;
    final newSeenTips = {...currentTips};
    bool hasChanges = false;

    for (final tipId in zoomTipIds) {
      if (newSeenTips.remove(tipId)) {
        hasChanges = true;
      }
    }

    if (hasChanges) {
      state = AsyncValue.data(newSeenTips);
      final prefs = await ref.read(sharedPreferencesProvider.future);
      await prefs.setStringList(_seenTipsKey, newSeenTips.toList());
    }
  }
}
