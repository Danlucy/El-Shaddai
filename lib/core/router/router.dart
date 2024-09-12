import 'package:el_shaddai/features/auth/controller/auth_controller.dart';
import 'package:el_shaddai/features/auth/presentations/login_screen.dart';
import 'package:el_shaddai/features/auth/presentations/zoom_screen.dart';
import 'package:el_shaddai/features/booking/presentations/booking_screen.dart';
import 'package:el_shaddai/features/home/presentations/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

part 'router.g.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: navigatorKey,
    redirect: (BuildContext context, GoRouterState state) {
      final userData = ref.watch(authStateChangeProvider).value;
      final loggedIn = userData != null;
      final bool loggingIn = state.matchedLocation == LoginRoute().location;

      if (!loggedIn && !loggingIn) {
        return LoginRoute(from: state.matchedLocation).location;
      }
      if (loggedIn && loggingIn) {
        return const HomeRoute().location;
      }
      return null;
    },
    routes: $appRoutes,
    initialLocation: '/events',
  );
});

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<EventsRoute>(
      path: 'events',
    ),
    TypedGoRoute<ZoomRoute>(
      path: 'zoom',
    ),
  ],
)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

class EventsRoute extends GoRouteData {
  const EventsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const BookingScreen();
}

class ZoomRoute extends GoRouteData {
  const ZoomRoute(this.url);
  final String? url;
  @override
  Widget build(BuildContext context, GoRouterState state) => ZoomScreen(url);
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData {
  LoginRoute({this.from});
  final String? from;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LoginScreen(from: from);
  }
}
