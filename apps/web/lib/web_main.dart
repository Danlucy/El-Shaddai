import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WebApp extends ConsumerStatefulWidget {
  const WebApp({super.key});

  @override
  ConsumerState createState() => _WebAppState();
}

class _WebAppState extends ConsumerState<WebApp> {
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'El Shaddai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(titleSpacing: 0),
          textTheme: textTheme,
          useMaterial3: true,
          colorScheme: MaterialTheme.darkScheme()),
      darkTheme: ThemeData(
          appBarTheme: const AppBarTheme(titleSpacing: 0),
          textTheme: textTheme,
          useMaterial3: true,
          colorScheme: MaterialTheme.darkScheme()),
      routerConfig: router,
    );
  }
}
