import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
