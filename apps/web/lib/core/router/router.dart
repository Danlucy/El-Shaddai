import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:website/features/booking/presentations/booking_details_screen.dart';
import 'package:website/features/booking/presentations/booking_list_screen.dart';
import 'package:website/features/booking/presentations/booking_screen.dart';
import 'package:website/features/home/presenations/home_screen.dart';
import 'package:website/features/home/presenations/shell_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

// SOLUTION 1: Use child routes (Recommended)
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
          // Booking tab with child routes
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/booking',
                builder: (context, state) => const BookingScreen(),
                routes: [
                  // Child route - URL becomes /booking/details/:id
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final String bookingId = state.pathParameters['id']!;
                      return BookingDetailsScreen(bookingId: bookingId);
                    },
                  ),
                ],
              ),
            ],
          ),
          // List tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/list',
                builder: (context, state) => BookingListScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
