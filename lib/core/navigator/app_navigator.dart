import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extension.dart';

import 'package:waterbus/core/navigator/app_navigator_observer.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/navigator/app_scaffold.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/features/archived/presentation/screens/archived_conversation_screen.dart';
import 'package:waterbus/features/archived/presentation/screens/archived_screen.dart';
import 'package:waterbus/features/auth/presentation/screens/login_screen.dart';
import 'package:waterbus/features/conversation/screens/conversation_screen.dart';
import 'package:waterbus/features/conversation/screens/detail_group_screen.dart';
import 'package:waterbus/features/home/screens/home.dart';
import 'package:waterbus/features/profile/presentation/screens/profile_screen.dart';
import 'package:waterbus/features/profile/presentation/screens/username_screen.dart';
import 'package:waterbus/features/room/presentation/screens/background_gallery.dart';
import 'package:waterbus/features/room/presentation/screens/create_meeting_screen.dart';
import 'package:waterbus/features/room/presentation/screens/enter_meeting_code_screen.dart';
import 'package:waterbus/features/room/presentation/screens/room_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/call_settings_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/language_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/notification_settings_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/privacy_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/settings_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/theme_screen.dart';

class AppNavigator extends RouteObserver<PageRoute<dynamic>> {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static GlobalKey<NavigatorState> navigatorHomeKey = GlobalKey();

  Route<dynamic> getRoute(RouteSettings settings) {
    final Map<String, dynamic>? arguments = _getArguments(settings);
    switch (settings.name) {
      case Routes.rootRoute:
        return _buildRoute(
          settings,
          const Home(),
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
      case Routes.usernameRoute:
        return _buildRoute(
          settings,
          const UserNameScreen(),
        );
      case Routes.settingsCallRoute:
        return _buildRoute(
          settings,
          const CallSettingsScreen(),
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
      case Routes.notificationSettings:
        return _buildRoute(
          settings,
          const NotificationSettingsScreen(),
        );
      // Meeting
      case Routes.roomRoute:
        return _buildRoute(
          RouteSettings(
            name: '${Routes.roomRoute}'
                '${arguments?['room'].code.toString()}',
          ),
          const RoomScreen(),
        );
      case Routes.createMeetingRoute:
        return _buildRoute(
          settings,
          CreateMeetingScreen(
            room: arguments?['room'],
            isChatScreen: arguments?['isChatScreen'] ?? false,
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
          ConversationScreen(
            room: arguments!['room'],
          ),
        );
      case Routes.archivedConversationRoute:
        return _buildRoute(
          settings,
          ArchivedConversationScreen(
            room: arguments!['room'],
          ),
        );
      case Routes.archivedRoute:
        return _buildRoute(
          settings,
          const ArchivedScreen(),
        );
      case Routes.langRoute:
        return _buildRoute(
          settings,
          const LanguageScreen(),
        );
      case Routes.themeRoute:
        return _buildRoute(
          settings,
          const ThemeScreen(),
        );
      case Routes.detailGroupRoute:
        return _buildRoute(
          settings,
          const DetailGroupScreen(),
        );
      default:
        return _buildRoute(
          const RouteSettings(name: Routes.rootRoute),
          const Home(),
        );
    }
  }

  _buildRoute(
    RouteSettings routeSettings,
    Widget builder,
  ) {
    return MaterialPageRoute(
      builder: (context) => AppScaffold(
        child: builder,
      ),
      settings: routeSettings,
    );
  }

  Future? push<T>(
    String route, {
    Object? arguments,
    bool forceRootState = false,
  }) {
    final bool hasMatchConditions = _middlewareRouter(route, arguments);

    if (hasMatchConditions) return null;

    return _currentState(route).pushNamed(route, arguments: arguments);
  }

  static Future pushNamedAndRemoveUntil<T>(
    String route, {
    Object? arguments,
  }) {
    if (route == Routes.rootRoute) {
      AppNavigatorObserver.resetRoutes();
    }

    return _currentState(route).pushNamedAndRemoveUntil(
      route,
      (route) => false,
      arguments: arguments,
    );
  }

  static Future? replaceWith<T>(
    String route, {
    Map<String, dynamic>? arguments,
  }) {
    return _currentState(route)
        .pushReplacementNamed(route, arguments: arguments);
  }

  static void popUntil<T>(String routeName) {
    state.popUntil((route) {
      if (route.isFirst) return true;

      return route.settings.name == routeName;
    });

    if (routeName == Routes.rootRoute) {
      popUntilHomeContext();
    }
  }

  static void pop() {
    if (!canPop) return;

    _currentState(AppNavigatorObserver.currentRouteName).pop();
  }

  _getArguments(RouteSettings settings) {
    return settings.arguments;
  }

  static void popUntilHomeContext() {
    homeState?.popUntil((route) => route.isFirst);
  }

  static bool getRouteDesktop(String route) => [
        Routes.conversationRoute,
        Routes.archivedConversationRoute,
      ].contains(route);

  static NavigatorState _currentState(String? route) {
    late NavigatorState stateByContext;

    if (SizerUtil.isDesktop &&
        homeState != null &&
        getRouteDesktop(route ?? "")) {
      stateByContext = homeState!;
    } else {
      stateByContext = state;
    }

    return stateByContext;
  }

  static bool get canPop =>
      _currentState(AppNavigatorObserver.currentRouteName).canPop();

  static String? currentRoute() => AppNavigatorObserver.currentRouteName;

  static BuildContext? get context => navigatorKey.currentContext;

  static BuildContext? get homeContext =>
      AppNavigator.navigatorHomeKey.currentContext;

  static NavigatorState get state => navigatorKey.currentState!;

  static NavigatorState? get homeState =>
      AppNavigator.navigatorHomeKey.currentState;
}

extension AppNavigatorX on AppNavigator {
  bool _middlewareRouter(
    String route,
    Object? arguments,
  ) {
    if (shouldBeShowPopupInstrealOfScreen(route: route)) {
      bool flagShowingDialog = false;
      for (final String? routeName in AppNavigatorObserver.routeNames) {
        if (routeName != null && popupInstrealOfScreen.contains(routeName)) {
          flagShowingDialog = true;
          break;
        }
      }

      showDialogWaterbus(
        routeName: route,
        duration: 200.milliseconds.inMilliseconds,
        maxHeight: 100.h,
        maxWidth: 400.sp,
        barrierColor: flagShowingDialog ? Colors.transparent : null,
        borderRadius: 16.sp,
        child: Material(
          clipBehavior: Clip.hardEdge,
          shape: SuperellipseShape(
            borderRadius: BorderRadius.circular(16.sp),
          ),
          child: SizedBox(
            height: !SizerUtil.isLandscape ? 80.h : 90.h,
            child: AppScaffold(
              child: getWidgetByRoute(
                route: route,
                arguments: arguments as Map<String, dynamic>?,
              ),
            ),
          ),
        ),
      );

      return true;
    }

    return false;
  }

  bool shouldBeShowPopupInstrealOfScreen({required String route}) {
    if (SizerUtil.isMobile) return false;

    return popupInstrealOfScreen.contains(route);
  }

  List<String> get popupInstrealOfScreen => [
        Routes.enterCodeRoute,
        Routes.createMeetingRoute,
        Routes.profileRoute,
        Routes.usernameRoute,
        Routes.settingsCallRoute,
        Routes.langRoute,
        Routes.themeRoute,
        Routes.detailGroupRoute,
      ];

  Widget getWidgetByRoute({
    required String route,
    Map<String, dynamic>? arguments,
  }) {
    switch (route) {
      case Routes.enterCodeRoute:
        return const EnterMeetingCode();
      case Routes.createMeetingRoute:
        return CreateMeetingScreen(
          room: arguments?['room'],
          isChatScreen: arguments?['isChatScreen'] ?? false,
        );
      case Routes.profileRoute:
        return const ProfileScreen();

      case Routes.usernameRoute:
        return const UserNameScreen();
      case Routes.settingsCallRoute:
        return const CallSettingsScreen();
      case Routes.langRoute:
        return const LanguageScreen();
      case Routes.themeRoute:
        return const ThemeScreen();
      case Routes.detailGroupRoute:
        return const DetailGroupScreen();
      default:
        return const SizedBox();
    }
  }
}
