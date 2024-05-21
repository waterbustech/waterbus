import 'package:flutter/material.dart';
import 'package:waterbus/core/navigator/app_routes.dart';

class AppNavigatorObserver extends NavigatorObserver {
  static List<String?> routeNames = [];

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    final String? name =
        route.settings.name?.startsWith(Routes.meetingRoute) ?? false
            ? Routes.meetingRoute
            : route.settings.name;

    routeNames.add(name);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (routeNames.length > 1) {
      routeNames.removeLast();
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace();
    routeNames[routeNames.length - 1] = newRoute?.settings.name ?? '';
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);

    final int indexOfRoute = routeNames.indexOf(route.settings.name ?? '');
    if (indexOfRoute != -1) {
      routeNames.removeRange(indexOfRoute, routeNames.length);
    }
  }

  // Static
  static String? get currentRouteName => routeNames.lastWhere(
        (route) => route != null && route.isNotEmpty,
        orElse: () => null,
      );

  static void resetRoutes() {
    routeNames = [];
  }
}
