import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/widgets/glass_container.dart';
import 'package:mobile/features/auth/controller/auth_controller.dart';
import 'package:repositories/repositories.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

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
    ref.watch(userProvider);
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.all(10),
        titleSpacing: 0,
        centerTitle: true,
        title: ref
            .watch(organizationControllerProvider)
            .when(
              data: (organization) {
                return IntrinsicWidth(
                  stepWidth: 100,
                  child: GlassContainer(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                    borderRadius: BorderRadius.circular(16),
                    height: 40,
                    width: double.infinity,
                    blur: 12,
                    child: Center(
                      child: GradientText(
                        colors: [
                          context.colors.primary,
                          context.colors.primary,
                          context.colors.secondary,
                        ],
                        organization.displayName,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
              error: (error, stack) => Text('Error: $error'),
              loading: () => const CircularProgressIndicator(),
            ),
      ),
      drawer: const GeneralDrawer(),
      body: SafeArea(
        bottom: true,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),

            // IconButton(
            //   onPressed: () async {
            //     try {
            //       // Also reset all tips to be sure
            //       await ref
            //           .read(onboardingNotifierProvider.notifier)
            //           .resetAllTips();
            //
            //       // Force refresh the provider state
            //       ref.invalidate(onboardingNotifierProvider);
            //
            //       // Wait a bit for the state to update
            //       await Future.delayed(const Duration(milliseconds: 100));
            //
            //       // Debug: Check the state after reset
            //       final hasSeenTip = ref
            //           .read(onboardingNotifierProvider.notifier)
            //           .hasSeenTip('zoom_input_tour_tip');
            //
            //       print(
            //           'DEBUG: Reset completed. Has seen zoom tip: $hasSeenTip');
            //       print(
            //           'DEBUG: Current venue state: ${ref.read(bookingVenueStateProvider)}');
            //
            //       // Show confirmation
            //       if (context.mounted) {
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           SnackBar(
            //             content: Text(
            //                 'Tips reset! Has seen zoom tip: $hasSeenTip\nSwitch to Zoom/Hybrid mode to see showcase.'),
            //             duration: const Duration(seconds: 3),
            //           ),
            //         );
            //       }
            //     } catch (e) {
            //       print('DEBUG: Error resetting tips: $e');
            //       if (context.mounted) {
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           SnackBar(content: Text('Error: $e')),
            //         );
            //       }
            //     }
            //   },
            //   icon: const Icon(Icons.settings),
            // ),
            // IconButton(
            //   onPressed: () async {
            //
            //   },
            //   icon: const Icon(Icons.settings),
            // ),
            user.when(
              data: (data) {
                sleep(Duration(milliseconds: 500));
                if (data?.phoneNumber == null) {
                  return Animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                    effects: [
                      BoxShadowEffect(
                        begin: BoxShadow(
                          color: Colors.red.withOpac(0.2),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),

                        end: BoxShadow(
                          color: Colors.red.withOpac(0.4),
                          blurRadius: 10,
                          spreadRadius: 4,
                        ),

                        duration: 2000.ms,
                        curve: Curves.easeInOut,
                      ),
                    ],
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Colors.red.withOpac(0.4),
                          width: 1,
                        ),
                      ),
                      color: Colors.red.withOpac(0.1),
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Please add your Phone number at the Profile.',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return SizedBox();
              },
              error: (e, x) => SizedBox(),
              loading: () => SizedBox(),
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
