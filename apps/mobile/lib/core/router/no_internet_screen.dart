import 'package:constants/constants.dart';
import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: textTheme,
          useMaterial3: true,
          colorScheme: MaterialTheme.darkScheme()),
      darkTheme: ThemeData(
          textTheme: textTheme,
          useMaterial3: true,
          colorScheme: MaterialTheme.darkScheme()),
      home: const Scaffold(
        body: Center(
          child: Text(
            'No Internet ¯\\_(ツ)_/¯',
            style: TextStyle(
                color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
