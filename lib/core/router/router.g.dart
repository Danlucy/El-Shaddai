// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeRoute,
      $loginRoute,
      $noInternetRoute,
    ];

RouteBase get $homeRoute => GoRouteData.$route(
      path: '/',
      factory: $HomeRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'booking',
          factory: $BookingRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'zoom',
          factory: $ZoomRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'profile',
          factory: $ProfileRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'booking-list',
          factory: $BookingListRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'user-management',
          factory: $UserManagementRouteExtension._fromState,
        ),
      ],
    );

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $BookingRouteExtension on BookingRoute {
  static BookingRoute _fromState(GoRouterState state) => const BookingRoute();

  String get location => GoRouteData.$location(
        '/booking',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ZoomRouteExtension on ZoomRoute {
  static ZoomRoute _fromState(GoRouterState state) => ZoomRoute(
        state.uri.queryParameters['url'],
      );

  String get location => GoRouteData.$location(
        '/zoom',
        queryParams: {
          if (url != null) 'url': url,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ProfileRouteExtension on ProfileRoute {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  String get location => GoRouteData.$location(
        '/profile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $BookingListRouteExtension on BookingListRoute {
  static BookingListRoute _fromState(GoRouterState state) =>
      const BookingListRoute();

  String get location => GoRouteData.$location(
        '/booking-list',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $UserManagementRouteExtension on UserManagementRoute {
  static UserManagementRoute _fromState(GoRouterState state) =>
      const UserManagementRoute();

  String get location => GoRouteData.$location(
        '/user-management',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginRoute => GoRouteData.$route(
      path: '/login',
      factory: $LoginRouteExtension._fromState,
    );

extension $LoginRouteExtension on LoginRoute {
  static LoginRoute _fromState(GoRouterState state) => LoginRoute(
        from: state.uri.queryParameters['from'],
      );

  String get location => GoRouteData.$location(
        '/login',
        queryParams: {
          if (from != null) 'from': from,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $noInternetRoute => GoRouteData.$route(
      path: '/no-internet',
      factory: $NoInternetRouteExtension._fromState,
    );

extension $NoInternetRouteExtension on NoInternetRoute {
  static NoInternetRoute _fromState(GoRouterState state) =>
      const NoInternetRoute();

  String get location => GoRouteData.$location(
        '/no-internet',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
