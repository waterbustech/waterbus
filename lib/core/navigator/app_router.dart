import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/navigator/app_navigator_observer.dart';
import 'package:waterbus/core/navigator/app_scaffold.dart';
import 'package:waterbus/core/navigator/routes.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/archived/presentation/screens/archived_conversation_screen.dart';
import 'package:waterbus/features/archived/presentation/screens/archived_screen.dart';
import 'package:waterbus/features/auth/presentation/screens/login_screen.dart';
import 'package:waterbus/features/chats/presentation/screens/chats_screen.dart';
import 'package:waterbus/features/conversation/screens/conversation_screen.dart';
import 'package:waterbus/features/conversation/screens/detail_group_screen.dart';
import 'package:waterbus/features/home/screens/home.dart';
import 'package:waterbus/features/home/screens/lobby_screen.dart';
import 'package:waterbus/features/home/widgets/recent_meetings.dart';
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
import 'package:waterbus/gen/assets.gen.dart';

part 'app_router.g.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: "_rootNavigatorKey");

  late final GoRouter router;
  static final AppRouter instance = AppRouter._internal();

  AppRouter._internal() {
    router = GoRouter(
      routes: $appRoutes,
      observers: [AppNavigatorObserver()],
      navigatorKey: _rootNavigatorKey,
      initialLocation: Routes.rootRoute,
    );
  }

  static void pop() {
    if (!canPop) return;

    _currentState(AppNavigatorObserver.currentRoute).pop();
  }

  static bool getRouteDesktop(String route) => [
        Routes.home + Routes.conversationRoute,
        Routes.home + Routes.archivedConversationRoute,
      ].contains(route);

  static NavigatorState _currentState(String? route) {
    late NavigatorState stateByContext;

    stateByContext = state;

    return stateByContext;
  }

  static bool get canPop =>
      _currentState(AppNavigatorObserver.currentRoute).canPop();

  static BuildContext? get context => _rootNavigatorKey.currentContext;

  static NavigatorState get state => _rootNavigatorKey.currentState!;

  static Future? push<T>(
    String route, {
    Object? extra,
    bool forceRootState = false,
  }) {
    final bool hasMatchConditions = _middlewareRouter(route, extra);

    if (hasMatchConditions) return null;

    return context?.push(route, extra: extra);
  }

  static bool _middlewareRouter(
    String route,
    Object? arguments,
  ) {
    if (_shouldBeShowPopupInstrealOfScreen(route: route)) {
      bool flagShowingDialog = false;
      for (final String? routeName in AppNavigatorObserver.routeNames) {
        if (routeName != null && _popupInstrealOfScreen.contains(routeName)) {
          flagShowingDialog = true;
          break;
        }
      }

      showDialogWaterbus(
        routeName: route,
        duration: 200,
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
            height: !AppRouter.context!.isLandscape ? 80.h : 90.h,
            child: AppScaffold(
              child: _getWidgetByRoute(
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

  static bool _shouldBeShowPopupInstrealOfScreen({required String route}) {
    if (AppRouter.context?.isMobile ?? true) return false;

    return _popupInstrealOfScreen.contains(route);
  }

  static List<String> get _popupInstrealOfScreen => [
        Routes.enterCodeRoute,
        Routes.createMeetingRoute,
        Routes.profileRoute,
        Routes.usernameRoute,
        Routes.settingsCallRoute,
        Routes.langRoute,
        Routes.themeRoute,
        Routes.detailGroupRoute,
      ];

  static Widget _getWidgetByRoute({
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

abstract class WaterbusBaseRoute extends GoRouteData {
  Widget buildContent(BuildContext context, GoRouterState state);

  @override
  Page buildPage(BuildContext context, GoRouterState state) {
    return buildWaterbusPage(
      child: buildContent(context, state),
      state: state,
    );
  }

  Page<T> buildWaterbusPage<T>({
    required Widget child,
    required GoRouterState state,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: AppScaffold(child: child),
      transitionDuration:
          kIsWeb ? Duration.zero : const Duration(milliseconds: 200),
      reverseTransitionDuration:
          kIsWeb ? Duration.zero : const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}

@TypedGoRoute<RootRoute>(path: Routes.rootRoute, name: Routes.rootRoute)
class RootRoute extends WaterbusBaseRoute with _$RootRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) =>
      const Home();
}

@TypedGoRoute<AuthenticationRoute>(
  path: Routes.authenticationRoute,
  name: Routes.authenticationRoute,
)
class AuthenticationRoute extends WaterbusBaseRoute with _$AuthenticationRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) =>
      const Scaffold();
}

@TypedGoRoute<LoginRoute>(path: Routes.loginRoute, name: Routes.loginRoute)
class LoginRoute extends WaterbusBaseRoute with _$LoginRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) =>
      const LogInScreen();
}

@TypedGoRoute<ProfileRoute>(
  path: Routes.profileRoute,
  name: Routes.profileRoute,
)
class ProfileRoute extends WaterbusBaseRoute with _$ProfileRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) =>
      const ProfileScreen();
}

@TypedGoRoute<UsernameRoute>(
  path: Routes.usernameRoute,
  name: Routes.usernameRoute,
)
class UsernameRoute extends WaterbusBaseRoute with _$UsernameRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) =>
      const UserNameScreen();
}

@TypedGoRoute<SettingsCallRoute>(
  path: Routes.settingsCallRoute,
  name: Routes.settingsCallRoute,
)
class SettingsCallRoute extends WaterbusBaseRoute with _$SettingsCallRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) =>
      const CallSettingsScreen();
}

@TypedGoRoute<SettingsRoute>(
  path: Routes.settingsRoute,
  name: Routes.settingsRoute,
)
class SettingsRoute extends WaterbusBaseRoute with _$SettingsRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}

@TypedGoRoute<PrivacyRoute>(
  path: Routes.privacyRoute,
  name: Routes.privacyRoute,
)
class PrivacyRoute extends WaterbusBaseRoute with _$PrivacyRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) =>
      const PrivacyScreen();
}

@TypedGoRoute<NotificationSettingsRoute>(
  path: Routes.notificationSettings,
  name: Routes.notificationSettings,
)
class NotificationSettingsRoute extends WaterbusBaseRoute
    with _$NotificationSettingsRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) =>
      const NotificationSettingsScreen();
}

@TypedGoRoute<RoomRoute>(path: Routes.roomRoute, name: Routes.roomRoute)
class RoomRoute extends WaterbusBaseRoute with _$RoomRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) =>
      const RoomScreen();
}

@TypedGoRoute<LobbyRoute>(path: Routes.lobbyRoute, name: Routes.lobbyRoute)
class LobbyRoute extends WaterbusBaseRoute with _$LobbyRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) => LobbyScreen(
        room: (state.extra as Map<String, dynamic>?)?['room'],
        isMember: (state.extra as Map<String, dynamic>?)?['isMember'],
        audioInputResponse:
            (state.extra as Map<String, dynamic>?)?['audioInputResponse'],
      );
}

@TypedGoRoute<CreateMeetingRoute>(
  path: Routes.createMeetingRoute,
  name: Routes.createMeetingRoute,
)
class CreateMeetingRoute extends WaterbusBaseRoute with _$CreateMeetingRoute {
  CreateMeetingRoute();

  @override
  Widget buildContent(BuildContext context, GoRouterState state) =>
      CreateMeetingScreen(
        room: (state.extra as Map<String, dynamic>?)?['room'],
        isChatScreen:
            (state.extra as Map<String, dynamic>?)?['isChatScreen'] ?? false,
      );
}

@TypedGoRoute<EnterCodeRoute>(
  path: Routes.enterCodeRoute,
  name: Routes.enterCodeRoute,
)
class EnterCodeRoute extends WaterbusBaseRoute with _$EnterCodeRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) =>
      const EnterMeetingCode();
}

@TypedGoRoute<BackgroundGalleryRoute>(
  path: Routes.backgroundGallery,
  name: Routes.backgroundGallery,
)
class BackgroundGalleryRoute extends WaterbusBaseRoute
    with _$BackgroundGalleryRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) =>
      const BackgroundGalleryScreen();
}

@TypedGoRoute<ConversationRoute>(
  path: Routes.conversationRoute,
  name: Routes.conversationRoute,
)
class ConversationRoute extends WaterbusBaseRoute with _$ConversationRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) =>
      ConversationScreen(room: (state.extra as Map<String, dynamic>?)?['room']);
}

@TypedGoRoute<ArchivedConversationRoute>(
  path: Routes.archivedConversationRoute,
  name: Routes.archivedConversationRoute,
)
class ArchivedConversationRoute extends WaterbusBaseRoute
    with _$ArchivedConversationRoute {
  ArchivedConversationRoute();

  @override
  Widget buildContent(BuildContext context, GoRouterState state) =>
      ArchivedConversationScreen(
        room: (state.extra as Map<String, dynamic>?)?['room'],
      );
}

@TypedGoRoute<ArchivedRoute>(
  path: Routes.archivedRoute,
  name: Routes.archivedRoute,
)
class ArchivedRoute extends WaterbusBaseRoute with _$ArchivedRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) =>
      const ArchivedScreen();
}

@TypedGoRoute<LangRoute>(
  path: Routes.langRoute,
  name: Routes.langRoute,
)
class LangRoute extends WaterbusBaseRoute with _$LangRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) =>
      const LanguageScreen();
}

@TypedGoRoute<ThemeRoute>(
  path: Routes.themeRoute,
  name: Routes.themeRoute,
)
class ThemeRoute extends WaterbusBaseRoute with _$ThemeRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) =>
      const ThemeScreen();
}

@TypedGoRoute<DetailGroupRoute>(
  path: Routes.detailGroupRoute,
  name: Routes.detailGroupRoute,
)
class DetailGroupRoute extends WaterbusBaseRoute with _$DetailGroupRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) =>
      const DetailGroupScreen();
}

@TypedGoRoute<ChatRoute>(
  path: Routes.chatRoute,
  name: Routes.chatRoute,
)
class ChatRoute extends WaterbusBaseRoute with _$ChatRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) =>
      const ChatsScreen();
}

@TypedGoRoute<RecentRoute>(
  path: Routes.recentRoute,
  name: Routes.recentRoute,
)
class RecentRoute extends WaterbusBaseRoute with _$RecentRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) =>
      const RecentMeetings();
}

@TypedGoRoute<LicenseRoute>(
  path: Routes.licensesRoute,
  name: Routes.licensesRoute,
)
class LicenseRoute extends WaterbusBaseRoute with _$LicenseRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) => LicensePage(
        applicationIcon: Image.asset(
          Assets.icons.launcherIcon.path,
          height: 35.sp,
        ),
        applicationVersion: kAppVersion,
      );
}
<<<<<<< HEAD
=======

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: "_rootNavigatorKey");

  late final GoRouter router;
  static final AppRouter instance = AppRouter._internal();

  AppRouter._internal() {
    router = GoRouter(
      routes: $appRoutes,
      observers: [AppNavigatorObserver()],
      navigatorKey: _rootNavigatorKey,
      initialLocation: Routes.rootRoute,
    );
  }

  static void pop() {
    if (!canPop) return;

    _currentState(AppNavigatorObserver.currentRouteName).pop();
  }

  static bool getRouteDesktop(String route) => [
        Routes.home + Routes.conversationRoute,
        Routes.home + Routes.archivedConversationRoute,
      ].contains(route);

  static NavigatorState _currentState(String? route) {
    late NavigatorState stateByContext;

    stateByContext = state;

    return stateByContext;
  }

  static bool get canPop =>
      _currentState(AppNavigatorObserver.currentRouteName).canPop();

  static String? currentRoute() => AppNavigatorObserver.currentRouteName;

  static BuildContext? get context => _rootNavigatorKey.currentContext;

  static NavigatorState get state => _rootNavigatorKey.currentState!;
}

bool middlewareRouter(
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
      duration: 200,
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
          height: !AppRouter.context!.isLandscape ? 80.h : 90.h,
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
  if (AppRouter.context?.isMobile ?? true) return false;

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
>>>>>>> b100c95e3e9d0f412699de02c56e4fdf7adf20eb
