import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:waterbus_sdk/types/index.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extension.dart';

import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/navigator/app_scaffold.dart';
import 'package:waterbus/core/navigator/routes.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
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
      navigatorKey: _rootNavigatorKey,
      initialLocation: Routes.rootRoute,
    );
  }

  static void pop() {
    if (!canPop) return;

    state.pop();
  }

  static bool get canPop => state.canPop();

  static void popUntil<T>({String routeName = Routes.rootRoute}) {
    state.popUntil((route) {
      if (route.isFirst) return true;

      return route.settings.name == routeName;
    });
  }

  String get currentRoute => router.state.path ?? "";

  static BuildContext? get context => _rootNavigatorKey.currentContext;

  static NavigatorState get state => _rootNavigatorKey.currentState!;
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
      name: state.name,
      key: state.pageKey,
      child: AppScaffold(child: child),
      transitionDuration: (kIsWeb ? 0 : 200).milliseconds,
      reverseTransitionDuration: (kIsWeb ? 0 : 200).milliseconds,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (kIsWeb) {
          return child;
        }

        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}

@TypedGoRoute<RootRoute>(path: Routes.rootRoute, name: Routes.rootRoute)
class RootRoute extends WaterbusBaseRoute with _$RootRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) {
    return const Home();
  }
}

@TypedGoRoute<AuthenticationRoute>(
  path: Routes.authenticationRoute,
  name: Routes.authenticationRoute,
)
class AuthenticationRoute extends WaterbusBaseRoute with _$AuthenticationRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) {
    return const Scaffold();
  }
}

@TypedGoRoute<LoginRoute>(path: Routes.loginRoute, name: Routes.loginRoute)
class LoginRoute extends WaterbusBaseRoute with _$LoginRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) {
    return const LogInScreen();
  }
}

@TypedGoRoute<ProfileRoute>(
  path: Routes.profileRoute,
  name: Routes.profileRoute,
)
class ProfileRoute extends WaterbusBaseRoute with _$ProfileRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) {
    return const ProfileScreen();
  }
}

@TypedGoRoute<UsernameRoute>(
  path: Routes.usernameRoute,
  name: Routes.usernameRoute,
)
class UsernameRoute extends WaterbusBaseRoute with _$UsernameRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) {
    return const UserNameScreen();
  }
}

@TypedGoRoute<CallSettingsRoute>(
  path: Routes.callSettingsRoute,
  name: Routes.callSettingsRoute,
)
class CallSettingsRoute extends WaterbusBaseRoute with _$CallSettingsRoute {
  final bool isInRoom;

  CallSettingsRoute({this.isInRoom = false});

  @override
  Widget buildContent(BuildContext context, GoRouterState state) {
    return CallSettingsScreen(isInRoom: isInRoom);
  }
}

@TypedGoRoute<SettingsRoute>(
  path: Routes.settingsRoute,
  name: Routes.settingsRoute,
)
class SettingsRoute extends WaterbusBaseRoute with _$SettingsRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) {
    return const SettingsScreen();
  }
}

@TypedGoRoute<PrivacyRoute>(
  path: Routes.privacyRoute,
  name: Routes.privacyRoute,
)
class PrivacyRoute extends WaterbusBaseRoute with _$PrivacyRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) {
    return const PrivacyScreen();
  }
}

@TypedGoRoute<NotificationSettingsRoute>(
  path: Routes.notificationSettings,
  name: Routes.notificationSettings,
)
class NotificationSettingsRoute extends WaterbusBaseRoute
    with _$NotificationSettingsRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) {
    return const NotificationSettingsScreen();
  }
}

@TypedGoRoute<LobbyRoute>(
  path: '${Routes.lobbyRoute}/:code',
  name: '${Routes.lobbyRoute}/:code',
)
class LobbyRoute extends WaterbusBaseRoute with _$LobbyRoute {
  final String code;
  final LobbyScreenExtras $extra;

  LobbyRoute({required this.code, required this.$extra});

  @override
  Widget buildContent(BuildContext context, GoRouterState state) {
    return LobbyScreen(
      room: $extra.room,
      isMember: $extra.isMember,
      code: code,
    );
  }
}

@TypedGoRoute<CreateMeetingRoute>(
  path: Routes.createMeetingRoute,
  name: Routes.createMeetingRoute,
)
class CreateMeetingRoute extends WaterbusBaseRoute with _$CreateMeetingRoute {
  final Room? $extra;
  final bool isChatScreen;

  CreateMeetingRoute({this.$extra, this.isChatScreen = false});

  @override
  Widget buildContent(BuildContext context, GoRouterState state) {
    return CreateMeetingScreen(
      room: $extra,
      isChatScreen: isChatScreen,
    );
  }
}

@TypedGoRoute<EnterCodeRoute>(
  path: Routes.enterCodeRoute,
  name: Routes.enterCodeRoute,
)
class EnterCodeRoute extends WaterbusBaseRoute with _$EnterCodeRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) {
    return const EnterMeetingCode();
  }
}

@TypedGoRoute<BackgroundGalleryRoute>(
  path: Routes.backgroundGallery,
  name: Routes.backgroundGallery,
)
class BackgroundGalleryRoute extends WaterbusBaseRoute
    with _$BackgroundGalleryRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) {
    return const BackgroundGalleryScreen();
  }
}

@TypedGoRoute<ConversationRoute>(
  path: Routes.conversationRoute,
  name: Routes.conversationRoute,
)
class ConversationRoute extends WaterbusBaseRoute with _$ConversationRoute {
  final Room $extra;

  ConversationRoute({required this.$extra});

  @override
  Widget buildContent(BuildContext context, GoRouterState state) {
    return ConversationScreen(room: $extra);
  }
}

@TypedGoRoute<ArchivedConversationRoute>(
  path: Routes.archivedConversationRoute,
  name: Routes.archivedConversationRoute,
)
class ArchivedConversationRoute extends WaterbusBaseRoute
    with _$ArchivedConversationRoute {
  final Room $extra;

  ArchivedConversationRoute({required this.$extra});

  @override
  Widget buildContent(BuildContext context, GoRouterState state) {
    return ArchivedConversationScreen(room: $extra);
  }
}

@TypedGoRoute<ArchivedRoute>(
  path: Routes.archivedRoute,
  name: Routes.archivedRoute,
)
class ArchivedRoute extends WaterbusBaseRoute with _$ArchivedRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) {
    return const ArchivedScreen();
  }
}

@TypedGoRoute<LangRoute>(
  path: Routes.langRoute,
  name: Routes.langRoute,
)
class LangRoute extends WaterbusBaseRoute with _$LangRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) {
    return const LanguageScreen();
  }
}

@TypedGoRoute<ThemeRoute>(
  path: Routes.themeRoute,
  name: Routes.themeRoute,
)
class ThemeRoute extends WaterbusBaseRoute with _$ThemeRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) {
    return const ThemeScreen();
  }
}

@TypedGoRoute<DetailGroupRoute>(
  path: Routes.detailGroupRoute,
  name: Routes.detailGroupRoute,
)
class DetailGroupRoute extends WaterbusBaseRoute with _$DetailGroupRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) {
    return const DetailGroupScreen();
  }
}

@TypedGoRoute<ChatRoute>(
  path: Routes.chatRoute,
  name: Routes.chatRoute,
)
class ChatRoute extends WaterbusBaseRoute with _$ChatRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) {
    return const ChatsScreen();
  }
}

@TypedGoRoute<RecentRoute>(
  path: Routes.recentRoute,
  name: Routes.recentRoute,
)
class RecentRoute extends WaterbusBaseRoute with _$RecentRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) {
    return const RecentMeetings();
  }
}

@TypedGoRoute<LicenseRoute>(
  path: Routes.licensesRoute,
  name: Routes.licensesRoute,
)
class LicenseRoute extends WaterbusBaseRoute with _$LicenseRoute {
  @override
  Widget buildContent(BuildContext context, GoRouterState state) {
    return LicensePage(
      applicationIcon: Image.asset(
        Assets.icons.launcherIcon.path,
        height: 35.sp,
      ),
      applicationVersion: kAppVersion,
    );
  }
}

@TypedGoRoute<RoomRoute>(
  path: "${Routes.rootRoute}:code",
  name: "${Routes.rootRoute}:code",
)
class RoomRoute extends WaterbusBaseRoute with _$RoomRoute {
  final String code;

  RoomRoute({required this.code});

  @override
  Widget buildContent(BuildContext context, GoRouterState state) {
    if (AppBloc.roomBloc.currentRoom == null) {
      scheduleMicrotask(() {
        LobbyRoute(code: code, $extra: LobbyScreenExtras()).go(context);
      });
    }

    return const RoomScreen();
  }
}

class LobbyScreenExtras {
  final Room? room;
  final bool isMember;

  LobbyScreenExtras({this.room, this.isMember = false});
}
