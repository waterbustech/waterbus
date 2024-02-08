// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:waterbus/core/navigator/app_material_page_route.dart';
import 'package:waterbus/core/navigator/app_navigator_observer.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/navigator/app_scaffold.dart';
import 'package:waterbus/features/auth/presentation/screens/login_screen.dart';
import 'package:waterbus/features/conversation/screens/conversation_screen.dart';
import 'package:waterbus/features/home/screens/home_screen.dart';
import 'package:waterbus/features/meeting/presentation/screens/background_gallery.dart';
import 'package:waterbus/features/meeting/presentation/screens/create_meeting_screen.dart';
import 'package:waterbus/features/meeting/presentation/screens/enter_meeting_code_screen.dart';
import 'package:waterbus/features/meeting/presentation/screens/meeting_screen.dart';
import 'package:waterbus/features/profile/presentation/screens/profile_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/privacy_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/settings_screen.dart';

class AppNavigator extends RouteObserver<PageRoute<dynamic>> {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static GlobalKey<NavigatorState> navigatorAccountKey = GlobalKey();

  Route<dynamic> getRoute(RouteSettings settings) {
    final Map<String, dynamic>? arguments = _getArguments(settings);

    switch (settings.name) {
      case Routes.rootRoute:
        return _buildRoute(
          settings,
          const HomeScreen(),
        );

      // Authenication
      case Routes.authenticationRoute:
        return _buildRoute(
          settings,
          const Scaffold(),
        );

      case Routes.loginRoute:
        return _buildRoute(
          settings,
          const LogInScreen(),
        );

      // Users
      case Routes.profileRoute:
        return _buildRoute(
          settings,
          const ProfileScreen(),
        );
      case Routes.settingsRoute:
        return _buildRoute(
          settings,
          const SettingsScreen(),
        );
      case Routes.privacyRoute:
        return _buildRoute(
          settings,
          const PrivacyScreen(),
        );

      // Meeting
      case Routes.meetingRoute:
        return _buildRoute(
          settings,
          const MeetingScreen(),
        );
      case Routes.createMeetingRoute:
        return _buildRoute(
          settings,
          CreateMeetingScreen(
            meeting: arguments?['meeting'],
          ),
        );
      case Routes.enterCodeRoute:
        return _buildRoute(
          settings,
          const EnterMeetingCode(),
        );
      case Routes.backgroundGallery:
        return _buildRoute(
          settings,
          const BackgroundGalleryScreen(),
        );

      case Routes.conversationRoute:
        return _buildRoute(
          settings,
          const ConversationScreen(),
        );

      default:
        return _buildRoute(
          const RouteSettings(name: Routes.rootRoute),
          const HomeScreen(),
        );
    }
  }

  _buildRoute(
    RouteSettings routeSettings,
    Widget builder,
  ) {
    return AppMaterialPageRoute(
      builder: (context) => AppScaffold(
        child: builder,
      ),
      settings: routeSettings,
    );
  }

  static Future? push<T>(
    String route, {
    Object? arguments,
  }) {
    late NavigatorState stateByContext;

    stateByContext = state;

    return stateByContext.pushNamed(route, arguments: arguments);
  }

  static Future pushNamedAndRemoveUntil<T>(
    String route, {
    Object? arguments,
  }) {
    if (route == Routes.rootRoute) {
      AppNavigatorObserver.resetRoutes();
    }

    return state.pushNamedAndRemoveUntil(
      route,
      (route) => false,
      arguments: arguments,
    );
  }

  static Future? replaceWith<T>(
    String route, {
    Map<String, dynamic>? arguments,
  }) {
    return state.pushReplacementNamed(route, arguments: arguments);
  }

  static void popUntil<T>(String routeName) {
    state.popUntil((route) {
      if (route.isFirst) return true;

      return route.settings.name == routeName;
    });
  }

  static void pop() {
    if (!canPop) return;

    state.pop();
  }

  _getArguments(RouteSettings settings) {
    return settings.arguments;
  }

  static bool get canPop => state.canPop();

  static String? currentRoute() => AppNavigatorObserver.currentRouteName;

  static BuildContext? get context => navigatorKey.currentContext;

  static NavigatorState get state => navigatorKey.currentState!;
}
