import 'package:auto_size_text/auto_size_text.dart';
import 'package:constants/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/booking/controller/booking_controller.dart';
import 'package:mobile/features/tip/controller/onboarding_controller.dart';

import '../../auth/controller/auth_controller.dart';
import '../widgets/general_drawer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Future<void> printSharedPreferencesCache() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final Map<String, dynamic> allPrefs = prefs.getKeys().fold({}, (map, key) {
  //     map[key] = prefs.get(key); // Fetch and store all key-value pairs
  //     return map;
  //   });
  //
  //   // Print all SharedPreferences data
  //   print("Shared Preferences Cache:");
  //   allPrefs.forEach((key, value) {
  //     print('Key: $key, Value: $value');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${user?.name ?? 'User'}'),
      ),
      drawer: const GeneralDrawer(),
      body: SafeArea(
        bottom: true,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            IconButton(
              onPressed: () async {
                try {
                  // Also reset all tips to be sure
                  await ref
                      .read(onboardingNotifierProvider.notifier)
                      .resetAllTips();

                  // Force refresh the provider state
                  ref.invalidate(onboardingNotifierProvider);

                  // Wait a bit for the state to update
                  await Future.delayed(const Duration(milliseconds: 100));

                  // Debug: Check the state after reset
                  final hasSeenTip = ref
                      .read(onboardingNotifierProvider.notifier)
                      .hasSeenTip('zoom_input_tour_tip');

                  print(
                      'DEBUG: Reset completed. Has seen zoom tip: $hasSeenTip');
                  print(
                      'DEBUG: Current venue state: ${ref.read(bookingVenueStateProvider)}');

                  // Show confirmation
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Tips reset! Has seen zoom tip: $hasSeenTip\nSwitch to Zoom/Hybrid mode to see showcase.'),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                } catch (e) {
                  print('DEBUG: Error resetting tips: $e');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              icon: const Icon(Icons.settings),
            ),
            Expanded(
              child: AutoSizeText(
                minFontSize: 13,
                maxFontSize: 28,
                'Welcome to EL Shaddai 247 Prayer Altar for the Kingdom Of God. \n\nThe Lord has prompted us to create the 247 prayer event calendar. This development is made possible with the appointment of Daniel Ong Zhi En, undergraduate student of Swineburne University. \n We started the development of this application since July 2024. Keep us in prayer that the heart of our Father will be fulfilled through our young generation under our guidance. Amen',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: context.colors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
