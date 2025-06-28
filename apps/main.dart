// import 'dart:async';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'mobile/lib/core/router/no_internet_screen.dart';
// import 'mobile/lib/core/utility/backend_checker.dart';
// import 'mobile/lib/firebase_options.dart';
// import 'web/lib/web_main.dart';
//
// main() {
//   void main() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     // FirebaseCrashlytics.instance.crash();
//     // PlatformDispatcher.instance.onError = (error, stack) {
//     //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
//     //   return true;
//     // };
//     // Check both basic internet and Firebase connectivity
//     final ValueNotifier<bool> hasConnectivity =
//         ValueNotifier<bool>(await Backend.checkConnectivity());
//     // Periodically check connectivity and update the notifier
//     Timer.periodic(const Duration(seconds: 5), (timer) async {
//       final connectivity = await Backend.checkConnectivity();
//       if (hasConnectivity.value != connectivity) {
//         hasConnectivity.value = connectivity;
//       }
//     });
//
//     runApp(
//       ProviderScope(
//         child: ValueListenableBuilder<bool>(
//           valueListenable: hasConnectivity,
//           builder: (context, isConnected, child) {
//             if (isConnected) {
//               return kIsWeb ? const WebApp() : const MobileApp();
//             } else {
//               return const NoInternetScreen();
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
