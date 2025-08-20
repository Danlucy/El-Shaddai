// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$homeRoute, $loginRoute, $noInternetRoute];

RouteBase get $homeRoute => GoRouteData.$route(
  path: '/',
  factory: _$HomeRoute._fromState,
  routes: [
    GoRouteData.$route(path: 'booking', factory: _$BookingRoute._fromState),
    GoRouteData.$route(path: 'zoom', factory: _$ZoomRoute._fromState),
    GoRouteData.$route(path: 'profile', factory: _$ProfileRoute._fromState),
    GoRouteData.$route(path: 'contact-us', factory: _$AboutUsRoute._fromState),
    GoRouteData.$route(
      path: 'booking-list',
      factory: _$BookingListRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'intercessors-feed',
      factory: _$PrayerLeaderRoute._fromState,
    ),
    GoRouteData.$route(path: 'settings', factory: _$SettingsRoute._fromState),
    GoRouteData.$route(
      path: 'user-management',
      factory: _$UserManagementRoute._fromState,
    ),
  ],
);

mixin _$HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$BookingRoute on GoRouteData {
  static BookingRoute _fromState(GoRouterState state) => const BookingRoute();

  @override
  String get location => GoRouteData.$location('/booking');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$ZoomRoute on GoRouteData {
  static ZoomRoute _fromState(GoRouterState state) =>
      ZoomRoute(state.uri.queryParameters['url']);

  ZoomRoute get _self => this as ZoomRoute;

  @override
  String get location => GoRouteData.$location(
    '/zoom',
    queryParams: {if (_self.url != null) 'url': _self.url},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) =>
      ProfileRoute(state.extra as UserModel?);

  ProfileRoute get _self => this as ProfileRoute;

  @override
  String get location => GoRouteData.$location('/profile');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

mixin _$AboutUsRoute on GoRouteData {
  static AboutUsRoute _fromState(GoRouterState state) => const AboutUsRoute();

  @override
  String get location => GoRouteData.$location('/contact-us');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$BookingListRoute on GoRouteData {
  static BookingListRoute _fromState(GoRouterState state) =>
      const BookingListRoute();

  @override
  String get location => GoRouteData.$location('/booking-list');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$PrayerLeaderRoute on GoRouteData {
  static PrayerLeaderRoute _fromState(GoRouterState state) =>
      const PrayerLeaderRoute();

  @override
  String get location => GoRouteData.$location('/intercessors-feed');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$UserManagementRoute on GoRouteData {
  static UserManagementRoute _fromState(GoRouterState state) =>
      const UserManagementRoute();

  @override
  String get location => GoRouteData.$location('/user-management');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginRoute =>
    GoRouteData.$route(path: '/login', factory: _$LoginRoute._fromState);

mixin _$LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) =>
      LoginRoute(from: state.uri.queryParameters['from']);

  LoginRoute get _self => this as LoginRoute;

  @override
  String get location => GoRouteData.$location(
    '/login',
    queryParams: {if (_self.from != null) 'from': _self.from},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $noInternetRoute => GoRouteData.$route(
  path: '/no-internet',
  factory: _$NoInternetRoute._fromState,
);

mixin _$NoInternetRoute on GoRouteData {
  static NoInternetRoute _fromState(GoRouterState state) =>
      const NoInternetRoute();

  @override
  String get location => GoRouteData.$location('/no-internet');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
