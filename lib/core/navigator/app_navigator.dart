// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/navigator/app_navigator_observer.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/navigator/app_scaffold.dart';
import 'package:waterbus/core/types/extensions/duration_x.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/features/auth/presentation/screens/login_screen.dart';
import 'package:waterbus/features/conversation/screens/conversation_screen.dart';
import 'package:waterbus/features/home/screens/home.dart';
import 'package:waterbus/features/meeting/presentation/screens/background_gallery.dart';
import 'package:waterbus/features/meeting/presentation/screens/create_meeting_screen.dart';
import 'package:waterbus/features/meeting/presentation/screens/enter_meeting_code_screen.dart';
import 'package:waterbus/features/meeting/presentation/screens/meeting_screen.dart';
import 'package:waterbus/features/profile/presentation/screens/profile_screen.dart';
import 'package:waterbus/features/profile/presentation/screens/username_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/call_settings_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/language_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/privacy_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/settings_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/theme_screen.dart';

class AppNavigator extends RouteObserver<PageRoute<dynamic>> {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static GlobalKey<NavigatorState> navigatorSettingKey = GlobalKey();

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
          ConversationScreen(
            chatModel: arguments!['chatModel'],
          ),
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
  }) {
    final bool hasMatchConditions = _middlewareRouter(route, arguments);

    if (hasMatchConditions) return null;

    late NavigatorState stateByContext;

    if (SizerUtil.isDesktop && settingState != null) {
      stateByContext = settingState!;
    } else {
      stateByContext = state;
    }

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

  void navigatorSettingPopToRoot() {
    settingState?.popUntil((route) => route.isFirst);
  }

  static bool get canPop => state.canPop();

  static String? currentRoute() => AppNavigatorObserver.currentRouteName;

  static BuildContext? get context => navigatorKey.currentContext;

  static BuildContext? get settingContext =>
      AppNavigator.navigatorSettingKey.currentContext;

  static NavigatorState get state => navigatorKey.currentState!;

  static NavigatorState? get settingState =>
      AppNavigator.navigatorSettingKey.currentState;
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.sp),
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
    if (!SizerUtil.isDesktop) return false;

    return popupInstrealOfScreen.contains(route);
  }

  List<String> get popupInstrealOfScreen => [
        Routes.profileRoute,
        Routes.usernameRoute,
        Routes.settingsCallRoute,
        Routes.langRoute,
        Routes.themeRoute,
      ];

  Widget getWidgetByRoute({
    required String route,
    Map<String, dynamic>? arguments,
  }) {
    switch (route) {
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
      default:
        return const SizedBox();
    }
  }
}
