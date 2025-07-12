import 'dart:async';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/constants/constants.dart';
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
import 'package:waterbus/features/room/presentation/screens/enter_meeting_code_screen.dart';
import 'package:waterbus/features/room/presentation/screens/meeting_form_screen.dart';
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

  static void popUntilToRoot() {
    if (AppRouter.instance.currentRoute == Routes.rootRoute) {
      Navigator.of(context!, rootNavigator: true)
          .popUntil((route) => route.isFirst);
    } else {
      RootRoute().go(context!);
    }
  }

  static bool get canPop => state.canPop();

  String get currentRoute => router.state.path ?? "";

  static BuildContext? get context => _rootNavigatorKey.currentContext;

  static NavigatorState get state => _rootNavigatorKey.currentState!;
}

@TypedGoRoute<RootRoute>(path: Routes.rootRoute, name: Routes.rootRoute)
class RootRoute extends GoRouteData with _$RootRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Home();
  }
}

@TypedGoRoute<AuthenticationRoute>(
  path: Routes.authenticationRoute,
  name: Routes.authenticationRoute,
)
class AuthenticationRoute extends GoRouteData with _$AuthenticationRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Scaffold();
  }
}

@TypedGoRoute<LoginRoute>(path: Routes.loginRoute, name: Routes.loginRoute)
class LoginRoute extends GoRouteData with _$LoginRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LogInScreen();
  }
}

@TypedGoRoute<ProfileRoute>(
  path: Routes.profileRoute,
  name: Routes.profileRoute,
)
class ProfileRoute extends GoRouteData with _$ProfileRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProfileScreen();
  }
}

@TypedGoRoute<UsernameRoute>(
  path: Routes.usernameRoute,
  name: Routes.usernameRoute,
)
class UsernameRoute extends GoRouteData with _$UsernameRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const UserNameScreen();
  }
}

@TypedGoRoute<CallSettingsRoute>(
  path: Routes.callSettingsRoute,
  name: Routes.callSettingsRoute,
)
class CallSettingsRoute extends GoRouteData with _$CallSettingsRoute {
  final bool isInRoom;

  CallSettingsRoute({this.isInRoom = false});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CallSettingsScreen(isInRoom: isInRoom);
  }
}

@TypedGoRoute<SettingsRoute>(
  path: Routes.settingsRoute,
  name: Routes.settingsRoute,
)
class SettingsRoute extends GoRouteData with _$SettingsRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsScreen();
  }
}

@TypedGoRoute<PrivacyRoute>(
  path: Routes.privacyRoute,
  name: Routes.privacyRoute,
)
class PrivacyRoute extends GoRouteData with _$PrivacyRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PrivacyScreen();
  }
}

@TypedGoRoute<NotificationSettingsRoute>(
  path: Routes.notificationSettings,
  name: Routes.notificationSettings,
)
class NotificationSettingsRoute extends GoRouteData
    with _$NotificationSettingsRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NotificationSettingsScreen();
  }
}

@TypedGoRoute<LobbyRoute>(
  path: '${Routes.lobbyRoute}/:code',
  name: '${Routes.lobbyRoute}/:code',
)
class LobbyRoute extends GoRouteData with _$LobbyRoute {
  final String code;
  final LobbyScreenExtras $extra;

  LobbyRoute({required this.code, required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LobbyScreen(
      room: $extra.room,
      isMember: $extra.isMember,
      code: code,
    );
  }
}

@TypedGoRoute<NewRoomRoute>(
  path: Routes.newRoomRoute,
  name: Routes.newRoomRoute,
)
class NewRoomRoute extends GoRouteData with _$NewRoomRoute {
  final bool isChatScreen;

  NewRoomRoute({this.isChatScreen = false});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MeetingFormScreen(isChatScreen: isChatScreen);
  }
}

@TypedGoRoute<UpdateRoomRoute>(
  path: Routes.updateRoomRoute,
  name: Routes.updateRoomRoute,
)
class UpdateRoomRoute extends GoRouteData with _$UpdateRoomRoute {
  final bool isChatScreen;

  UpdateRoomRoute({this.isChatScreen = false});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MeetingFormScreen(
      isChatScreen: isChatScreen,
      isEdit: true,
    );
  }
}

@TypedGoRoute<EnterCodeRoute>(
  path: Routes.enterCodeRoute,
  name: Routes.enterCodeRoute,
)
class EnterCodeRoute extends GoRouteData with _$EnterCodeRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const EnterMeetingCode();
  }
}

@TypedGoRoute<BackgroundGalleryRoute>(
  path: Routes.backgroundGallery,
  name: Routes.backgroundGallery,
)
class BackgroundGalleryRoute extends GoRouteData with _$BackgroundGalleryRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const BackgroundGalleryScreen();
  }
}

@TypedGoRoute<ConversationRoute>(
  path: Routes.conversationRoute,
  name: Routes.conversationRoute,
)
class ConversationRoute extends GoRouteData with _$ConversationRoute {
  final Room $extra;

  ConversationRoute({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ConversationScreen(room: $extra);
  }
}

@TypedGoRoute<ArchivedConversationRoute>(
  path: Routes.archivedConversationRoute,
  name: Routes.archivedConversationRoute,
)
class ArchivedConversationRoute extends GoRouteData
    with _$ArchivedConversationRoute {
  final Room $extra;

  ArchivedConversationRoute({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ArchivedConversationScreen(room: $extra);
  }
}

@TypedGoRoute<ArchivedRoute>(
  path: Routes.archivedRoute,
  name: Routes.archivedRoute,
)
class ArchivedRoute extends GoRouteData with _$ArchivedRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ArchivedScreen();
  }
}

@TypedGoRoute<LangRoute>(
  path: Routes.langRoute,
  name: Routes.langRoute,
)
class LangRoute extends GoRouteData with _$LangRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LanguageScreen();
  }
}

@TypedGoRoute<ThemeRoute>(
  path: Routes.themeRoute,
  name: Routes.themeRoute,
)
class ThemeRoute extends GoRouteData with _$ThemeRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ThemeScreen();
  }
}

@TypedGoRoute<DetailGroupRoute>(
  path: Routes.detailGroupRoute,
  name: Routes.detailGroupRoute,
)
class DetailGroupRoute extends GoRouteData with _$DetailGroupRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DetailGroupScreen();
  }
}

@TypedGoRoute<ChatRoute>(
  path: Routes.chatRoute,
  name: Routes.chatRoute,
)
class ChatRoute extends GoRouteData with _$ChatRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChatsScreen();
  }
}

@TypedGoRoute<RecentRoute>(
  path: Routes.recentRoute,
  name: Routes.recentRoute,
)
class RecentRoute extends GoRouteData with _$RecentRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RecentMeetings();
  }
}

@TypedGoRoute<LicenseRoute>(
  path: Routes.licensesRoute,
  name: Routes.licensesRoute,
)
class LicenseRoute extends GoRouteData with _$LicenseRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
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
class RoomRoute extends GoRouteData with _$RoomRoute {
  final String code;

  RoomRoute({required this.code});

  @override
  Widget build(BuildContext context, GoRouterState state) {
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
