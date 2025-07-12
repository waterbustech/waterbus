// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $rootRoute,
      $authenticationRoute,
      $loginRoute,
      $profileRoute,
      $usernameRoute,
      $callSettingsRoute,
      $settingsRoute,
      $privacyRoute,
      $notificationSettingsRoute,
      $lobbyRoute,
      $newRoomRoute,
      $updateRoomRoute,
      $enterCodeRoute,
      $backgroundGalleryRoute,
      $conversationRoute,
      $archivedConversationRoute,
      $archivedRoute,
      $langRoute,
      $themeRoute,
      $detailGroupRoute,
      $chatRoute,
      $recentRoute,
      $licenseRoute,
      $roomRoute,
    ];

RouteBase get $rootRoute => GoRouteData.$route(
      path: '/',
      name: '/',
      factory: _$RootRoute._fromState,
    );

mixin _$RootRoute on GoRouteData {
  static RootRoute _fromState(GoRouterState state) => RootRoute();

  @override
  String get location => GoRouteData.$location(
        '/',
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

RouteBase get $authenticationRoute => GoRouteData.$route(
      path: '/authentication',
      name: '/authentication',
      factory: _$AuthenticationRoute._fromState,
    );

mixin _$AuthenticationRoute on GoRouteData {
  static AuthenticationRoute _fromState(GoRouterState state) =>
      AuthenticationRoute();

  @override
  String get location => GoRouteData.$location(
        '/authentication',
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

RouteBase get $loginRoute => GoRouteData.$route(
      path: '/login',
      name: '/login',
      factory: _$LoginRoute._fromState,
    );

mixin _$LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) => LoginRoute();

  @override
  String get location => GoRouteData.$location(
        '/login',
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

RouteBase get $profileRoute => GoRouteData.$route(
      path: '/profile',
      name: '/profile',
      factory: _$ProfileRoute._fromState,
    );

mixin _$ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) => ProfileRoute();

  @override
  String get location => GoRouteData.$location(
        '/profile',
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

RouteBase get $usernameRoute => GoRouteData.$route(
      path: '/username',
      name: '/username',
      factory: _$UsernameRoute._fromState,
    );

mixin _$UsernameRoute on GoRouteData {
  static UsernameRoute _fromState(GoRouterState state) => UsernameRoute();

  @override
  String get location => GoRouteData.$location(
        '/username',
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

RouteBase get $callSettingsRoute => GoRouteData.$route(
      path: '/callSettings',
      name: '/callSettings',
      factory: _$CallSettingsRoute._fromState,
    );

mixin _$CallSettingsRoute on GoRouteData {
  static CallSettingsRoute _fromState(GoRouterState state) => CallSettingsRoute(
        isInRoom: _$convertMapValue(
                'is-in-room', state.uri.queryParameters, _$boolConverter) ??
            false,
      );

  CallSettingsRoute get _self => this as CallSettingsRoute;

  @override
  String get location => GoRouteData.$location(
        '/callSettings',
        queryParams: {
          if (_self.isInRoom != false) 'is-in-room': _self.isInRoom.toString(),
        },
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

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}

RouteBase get $settingsRoute => GoRouteData.$route(
      path: '/settings',
      name: '/settings',
      factory: _$SettingsRoute._fromState,
    );

mixin _$SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => SettingsRoute();

  @override
  String get location => GoRouteData.$location(
        '/settings',
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

RouteBase get $privacyRoute => GoRouteData.$route(
      path: '/privacy',
      name: '/privacy',
      factory: _$PrivacyRoute._fromState,
    );

mixin _$PrivacyRoute on GoRouteData {
  static PrivacyRoute _fromState(GoRouterState state) => PrivacyRoute();

  @override
  String get location => GoRouteData.$location(
        '/privacy',
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

RouteBase get $notificationSettingsRoute => GoRouteData.$route(
      path: '/notification-settings',
      name: '/notification-settings',
      factory: _$NotificationSettingsRoute._fromState,
    );

mixin _$NotificationSettingsRoute on GoRouteData {
  static NotificationSettingsRoute _fromState(GoRouterState state) =>
      NotificationSettingsRoute();

  @override
  String get location => GoRouteData.$location(
        '/notification-settings',
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

RouteBase get $lobbyRoute => GoRouteData.$route(
      path: '/lobby/:code',
      name: '/lobby/:code',
      factory: _$LobbyRoute._fromState,
    );

mixin _$LobbyRoute on GoRouteData {
  static LobbyRoute _fromState(GoRouterState state) => LobbyRoute(
        code: state.pathParameters['code']!,
        $extra: state.extra as LobbyScreenExtras,
      );

  LobbyRoute get _self => this as LobbyRoute;

  @override
  String get location => GoRouteData.$location(
        '/lobby/${Uri.encodeComponent(_self.code)}',
      );

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

RouteBase get $newRoomRoute => GoRouteData.$route(
      path: '/room/new',
      name: '/room/new',
      factory: _$NewRoomRoute._fromState,
    );

mixin _$NewRoomRoute on GoRouteData {
  static NewRoomRoute _fromState(GoRouterState state) => NewRoomRoute(
        isChatScreen: _$convertMapValue(
                'is-chat-screen', state.uri.queryParameters, _$boolConverter) ??
            false,
      );

  NewRoomRoute get _self => this as NewRoomRoute;

  @override
  String get location => GoRouteData.$location(
        '/room/new',
        queryParams: {
          if (_self.isChatScreen != false)
            'is-chat-screen': _self.isChatScreen.toString(),
        },
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

RouteBase get $updateRoomRoute => GoRouteData.$route(
      path: '/room/update',
      name: '/room/update',
      factory: _$UpdateRoomRoute._fromState,
    );

mixin _$UpdateRoomRoute on GoRouteData {
  static UpdateRoomRoute _fromState(GoRouterState state) => UpdateRoomRoute(
        isChatScreen: _$convertMapValue(
                'is-chat-screen', state.uri.queryParameters, _$boolConverter) ??
            false,
      );

  UpdateRoomRoute get _self => this as UpdateRoomRoute;

  @override
  String get location => GoRouteData.$location(
        '/room/update',
        queryParams: {
          if (_self.isChatScreen != false)
            'is-chat-screen': _self.isChatScreen.toString(),
        },
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

RouteBase get $enterCodeRoute => GoRouteData.$route(
      path: '/enter-code',
      name: '/enter-code',
      factory: _$EnterCodeRoute._fromState,
    );

mixin _$EnterCodeRoute on GoRouteData {
  static EnterCodeRoute _fromState(GoRouterState state) => EnterCodeRoute();

  @override
  String get location => GoRouteData.$location(
        '/enter-code',
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

RouteBase get $backgroundGalleryRoute => GoRouteData.$route(
      path: '/background-gallery',
      name: '/background-gallery',
      factory: _$BackgroundGalleryRoute._fromState,
    );

mixin _$BackgroundGalleryRoute on GoRouteData {
  static BackgroundGalleryRoute _fromState(GoRouterState state) =>
      BackgroundGalleryRoute();

  @override
  String get location => GoRouteData.$location(
        '/background-gallery',
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

RouteBase get $conversationRoute => GoRouteData.$route(
      path: '/conversation',
      name: '/conversation',
      factory: _$ConversationRoute._fromState,
    );

mixin _$ConversationRoute on GoRouteData {
  static ConversationRoute _fromState(GoRouterState state) => ConversationRoute(
        $extra: state.extra as Room,
      );

  ConversationRoute get _self => this as ConversationRoute;

  @override
  String get location => GoRouteData.$location(
        '/conversation',
      );

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

RouteBase get $archivedConversationRoute => GoRouteData.$route(
      path: '/archived-conversation',
      name: '/archived-conversation',
      factory: _$ArchivedConversationRoute._fromState,
    );

mixin _$ArchivedConversationRoute on GoRouteData {
  static ArchivedConversationRoute _fromState(GoRouterState state) =>
      ArchivedConversationRoute(
        $extra: state.extra as Room,
      );

  ArchivedConversationRoute get _self => this as ArchivedConversationRoute;

  @override
  String get location => GoRouteData.$location(
        '/archived-conversation',
      );

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

RouteBase get $archivedRoute => GoRouteData.$route(
      path: '/archived',
      name: '/archived',
      factory: _$ArchivedRoute._fromState,
    );

mixin _$ArchivedRoute on GoRouteData {
  static ArchivedRoute _fromState(GoRouterState state) => ArchivedRoute();

  @override
  String get location => GoRouteData.$location(
        '/archived',
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

RouteBase get $langRoute => GoRouteData.$route(
      path: '/language',
      name: '/language',
      factory: _$LangRoute._fromState,
    );

mixin _$LangRoute on GoRouteData {
  static LangRoute _fromState(GoRouterState state) => LangRoute();

  @override
  String get location => GoRouteData.$location(
        '/language',
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

RouteBase get $themeRoute => GoRouteData.$route(
      path: '/appearance',
      name: '/appearance',
      factory: _$ThemeRoute._fromState,
    );

mixin _$ThemeRoute on GoRouteData {
  static ThemeRoute _fromState(GoRouterState state) => ThemeRoute();

  @override
  String get location => GoRouteData.$location(
        '/appearance',
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

RouteBase get $detailGroupRoute => GoRouteData.$route(
      path: '/detail-group',
      name: '/detail-group',
      factory: _$DetailGroupRoute._fromState,
    );

mixin _$DetailGroupRoute on GoRouteData {
  static DetailGroupRoute _fromState(GoRouterState state) => DetailGroupRoute();

  @override
  String get location => GoRouteData.$location(
        '/detail-group',
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

RouteBase get $chatRoute => GoRouteData.$route(
      path: '/chat',
      name: '/chat',
      factory: _$ChatRoute._fromState,
    );

mixin _$ChatRoute on GoRouteData {
  static ChatRoute _fromState(GoRouterState state) => ChatRoute();

  @override
  String get location => GoRouteData.$location(
        '/chat',
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

RouteBase get $recentRoute => GoRouteData.$route(
      path: '/recent',
      name: '/recent',
      factory: _$RecentRoute._fromState,
    );

mixin _$RecentRoute on GoRouteData {
  static RecentRoute _fromState(GoRouterState state) => RecentRoute();

  @override
  String get location => GoRouteData.$location(
        '/recent',
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

RouteBase get $licenseRoute => GoRouteData.$route(
      path: '/licenses',
      name: '/licenses',
      factory: _$LicenseRoute._fromState,
    );

mixin _$LicenseRoute on GoRouteData {
  static LicenseRoute _fromState(GoRouterState state) => LicenseRoute();

  @override
  String get location => GoRouteData.$location(
        '/licenses',
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

RouteBase get $roomRoute => GoRouteData.$route(
      path: '/:code',
      name: '/:code',
      factory: _$RoomRoute._fromState,
    );

mixin _$RoomRoute on GoRouteData {
  static RoomRoute _fromState(GoRouterState state) => RoomRoute(
        code: state.pathParameters['code']!,
      );

  RoomRoute get _self => this as RoomRoute;

  @override
  String get location => GoRouteData.$location(
        '/${Uri.encodeComponent(_self.code)}',
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
