import 'package:auto_size_text/auto_size_text.dart';
import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${'User'}'),
      ),
      body: SafeArea(
        bottom: true,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
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
