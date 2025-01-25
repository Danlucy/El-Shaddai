import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/features/auth/controller/auth_controller.dart';
import 'package:el_shaddai/features/home/widgets/general_drawer.dart';
import 'package:el_shaddai/features/participant/participant_controller/participant_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Text(
              'EL Shaddai  Prayer Altar 24/7 for the Kingdom Of God',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: context.colors.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
