import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/features/auth/controller/auth_controller.dart';
import 'package:el_shaddai/features/home/widgets/general_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${ref.watch(userProvider)?.name ?? 'User'}'),
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
