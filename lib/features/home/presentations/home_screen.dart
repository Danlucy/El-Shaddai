import 'package:el_shaddai/features/auth/controller/auth_controller.dart';
import 'package:el_shaddai/features/auth/repository/auth_repository.dart';
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
    final userData = ref.watch(authStateChangeProvider).value;

    if (userData != null) {
      ref
          .read(authControllerProvider.notifier)
          .getUserData(userData.uid)
          .first
          .then((userModel) {
        ref.read(userProvider.notifier).update((state) => userModel);
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${userData?.displayName ?? 'User'}'),
      ),
      drawer: GeneralDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              'EL Shaddai  Prayer Altar 24/7 for the Kingdom Of God',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
