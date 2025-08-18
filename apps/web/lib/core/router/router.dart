import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:website/features/booking/presentations/booking_details_screen.dart';
import 'package:website/features/booking/presentations/booking_list_screen.dart';
import 'package:website/features/booking/presentations/booking_screen.dart';
import 'package:website/features/home/presenations/home_screen.dart';
import 'package:website/features/home/presenations/shell_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Home tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Booking tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/booking',
                builder: (context, state) => const BookingScreen(),
              ),
              GoRoute(
                path: '/booking/list',
                builder: (context, state) {
                  return BookingListScreen();
                },
              ),
              GoRoute(
                path: '/booking/:id', // The path with the ID parameter
                builder: (context, state) {
                  // Extract the 'id' parameter from the URL
                  final String bookingId = state.pathParameters['id']!;
                  // Pass the ID to your details screen
                  return BookingDetailsScreen(bookingId: bookingId);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
