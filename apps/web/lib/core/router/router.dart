import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:website/features/booking/presentations/booking_component.dart';
import 'package:website/features/booking/presentations/booking_details_screen.dart';
import 'package:website/features/booking/presentations/booking_list_screen.dart';
import 'package:website/features/booking/presentations/booking_screen.dart';
import 'package:website/features/home/presenations/home_screen.dart';
import 'package:website/features/home/presenations/shell_screen.dart';
import 'package:website/features/settings/presentations/settings_screen.dart';

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
          // ... inside your Booking ShellBranch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/booking',
                builder: (context, state) => BookingScreen(),
                routes: [
                  // ---------------------------------------------------------
                  // 1. CREATE & EDIT ROUTES (Must come BEFORE :id)
                  // ---------------------------------------------------------
                  GoRoute(
                    path: 'create', // URL: /booking/create
                    pageBuilder: (context, state) {
                      return CustomTransitionPage(
                        key: state.pageKey,
                        // No ID passed = Create Mode
                        child: const BookingDialogPage(extraModel: null),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                        opaque: false,
                        barrierDismissible: true,
                        barrierColor: Colors.black54,
                        transitionDuration: const Duration(milliseconds: 300),
                      );
                    },
                    routes: [
                      // Sub-route for EDITING: matches /booking/create/:id
                      GoRoute(
                        path:
                            ':actionId', // Rename param to avoid conflict with detail's :id
                        pageBuilder: (context, state) {
                          final String id = state.pathParameters['actionId']!;
                          final BookingModel? extra =
                              state.extra as BookingModel?;

                          return CustomTransitionPage(
                            key: state.pageKey,
                            // ID passed = Edit Mode
                            child: BookingDialogPage(
                              extraModel: extra,
                            ), // You might want to pass 'id' here too if fetching
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                            opaque: false,
                            barrierDismissible: true,
                            barrierColor: Colors.black54,
                            transitionDuration: const Duration(
                              milliseconds: 200,
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  // ---------------------------------------------------------
                  // 2. DETAIL VIEW ROUTE (Must come AFTER create)
                  // ---------------------------------------------------------
                  GoRoute(
                    path: ':id', // URL: /booking/123
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
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
