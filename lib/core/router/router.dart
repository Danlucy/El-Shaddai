import 'package:el_shaddai/core/router/no_internet_screen.dart';
import 'package:el_shaddai/features/auth/controller/auth_controller.dart';
import 'package:el_shaddai/features/auth/presentations/login_screen.dart';
import 'package:el_shaddai/features/auth/presentations/zoom_screen.dart';
import 'package:el_shaddai/features/booking/presentations/booking_list_screen.dart';
import 'package:el_shaddai/features/booking/presentations/booking_screen.dart';
import 'package:el_shaddai/features/home/presentations/home_screen.dart';
import 'package:el_shaddai/features/profile/presentations/profile_screen.dart';
import 'package:el_shaddai/features/user_management/presentations/user_management_screen.dart';
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
    initialLocation: '/',
  );
});

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<BookingRoute>(
      path: 'booking',
    ),
    TypedGoRoute<ZoomRoute>(
      path: 'zoom',
    ),
    TypedGoRoute<ProfileRoute>(
      path: 'profile',
    ),
    TypedGoRoute<BookingListRoute>(
      path: 'booking-list',
    ),
    TypedGoRoute<UserManagementRoute>(
      path: 'user-management',
    ),
  ],
)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

class BookingRoute extends GoRouteData {
  const BookingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const BookingScreen();
}

class ProfileRoute extends GoRouteData {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfileScreen();
}

class BookingListRoute extends GoRouteData {
  const BookingListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const BookingListScreen();
}

class UserManagementRoute extends GoRouteData {
  const UserManagementRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const UserManagementScreen();
}

class ZoomRoute extends GoRouteData {
  const ZoomRoute(
    this.url,
  );
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

@TypedGoRoute<NoInternetRoute>(path: '/no-internet')
class NoInternetRoute extends GoRouteData {
  const NoInternetRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const NoInternetScreen();
}
