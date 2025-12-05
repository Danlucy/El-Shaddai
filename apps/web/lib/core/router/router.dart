import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:website/features/booking/presentations/booking_component.dart';
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
                builder: (context, state) => BookingScreen(),
                routes: [
                  // 1. CREATE NEW: Matches /booking/create
                  GoRoute(
                    path: 'create',
                    pageBuilder: (context, state) {
                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: const BookingDialogPage(extraModel: null),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                        opaque: false, // Allows BookingScreen to show behind
                        barrierDismissible: true,
                        barrierColor: Colors.black54, // Dark overlay color
                        barrierLabel: 'Dismiss',
                        transitionDuration: const Duration(milliseconds: 200),
                      );
                    },
                    routes: [
                      // 2. EDIT EXISTING: Matches /booking/create/:id
                      GoRoute(
                        path: ':id',
                        pageBuilder: (context, state) {
                          final String id = state.pathParameters['id']!;
                          final BookingModel? extra =
                              state.extra as BookingModel?;

                          return CustomTransitionPage(
                            key: state.pageKey,
                            child: BookingDialogPage(extraModel: extra),
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
                            opaque:
                                false, // Allows BookingScreen to show behind
                            barrierDismissible: true,
                            barrierColor: Colors.black54,
                            barrierLabel: 'Dismiss',
                            transitionDuration: const Duration(
                              milliseconds: 200,
                            ),
                          );
                        },
                      ),
                    ],
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
