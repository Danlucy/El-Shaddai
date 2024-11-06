import 'dart:convert';

import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/features/auth/controller/auth_controller.dart';
import 'package:el_shaddai/features/home/widgets/general_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          String? decodedMap = prefs.getString('accessToken');
          if (decodedMap != null) {
            print('rTOKEN');
            Map<String, dynamic> data = jsonDecode(decodedMap);
            print(data['refreshToken']);
            print(data['duration']);
            print(data['token']);
          }
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Welcome ${ref.read(userProvider)?.name ?? 'User'}'),
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
