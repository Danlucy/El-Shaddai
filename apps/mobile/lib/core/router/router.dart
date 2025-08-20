import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/settings/presentations/settings_screen.dart';
import 'package:models/models.dart';

import '../../features/auth/controller/auth_controller.dart';
import '../../features/auth/presentations/login_screen.dart';
import '../../features/auth/presentations/zoom_screen.dart';
import '../../features/booking/presentations/booking_list_screen.dart';
import '../../features/booking/presentations/booking_screen.dart';
import '../../features/home/presentations/home_screen.dart';
import '../../features/post/presentations/about_us_screens.dart';
import '../../features/post/presentations/prayer_leader_screen.dart';
import '../../features/profile/presentations/profile_screen.dart';
import '../../features/user_management/presentations/user_management_screen.dart';
import 'no_internet_screen.dart';

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
    TypedGoRoute<BookingRoute>(path: 'booking'),
    TypedGoRoute<ZoomRoute>(path: 'zoom'),
    TypedGoRoute<ProfileRoute>(path: 'profile'),
    TypedGoRoute<AboutUsRoute>(path: 'contact-us'),
    TypedGoRoute<BookingListRoute>(path: 'booking-list'),
    TypedGoRoute<PrayerLeaderRoute>(path: 'intercessors-feed'),
    TypedGoRoute<SettingsRoute>(path: 'settings'),
    TypedGoRoute<UserManagementRoute>(path: 'user-management'),
  ],
)
class HomeRoute extends GoRouteData with _$HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

class AboutUsRoute extends GoRouteData with _$AboutUsRoute {
  const AboutUsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AboutUsScreen();
}

class BookingRoute extends GoRouteData with _$BookingRoute {
  const BookingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const BookingScreen();
}

class ProfileRoute extends GoRouteData with _$ProfileRoute {
  const ProfileRoute(this.$extra);
  final UserModel? $extra;
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ProfileScreen(userModel: $extra);
}

class BookingListRoute extends GoRouteData with _$BookingListRoute {
  const BookingListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const BookingListScreen();
}

class PrayerLeaderRoute extends GoRouteData with _$PrayerLeaderRoute {
  const PrayerLeaderRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PrayerLeaderScreen();
}

class UserManagementRoute extends GoRouteData with _$UserManagementRoute {
  const UserManagementRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const UserManagementScreen();
}

class SettingsRoute extends GoRouteData with _$SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}

class ZoomRoute extends GoRouteData with _$ZoomRoute {
  const ZoomRoute(this.url);
  final String? url;
  @override
  Widget build(BuildContext context, GoRouterState state) => ZoomScreen(url);
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData with _$LoginRoute {
  LoginRoute({this.from});
  final String? from;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LoginScreen(from: from);
  }
}

@TypedGoRoute<NoInternetRoute>(path: '/no-internet')
class NoInternetRoute extends GoRouteData with _$NoInternetRoute {
  const NoInternetRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const NoInternetScreen();
}
