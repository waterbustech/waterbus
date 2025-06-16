// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sliding_drawer/flutter_sliding_drawer.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/navigator/routes.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/permission_handler.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/archived/presentation/screens/archived_screen.dart';
import 'package:waterbus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waterbus/features/chats/presentation/screens/chats_screen.dart';
import 'package:waterbus/features/common/widgets/app_bar_title_back.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/home/widgets/enter_code_box.dart';
import 'package:waterbus/features/home/widgets/recent_meetings.dart';
import 'package:waterbus/features/home/widgets/side_menu_widget.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';
import 'package:waterbus/features/profile/presentation/widgets/profile_drawer_layout.dart';
import 'package:waterbus/features/settings/presentation/screens/call_settings_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/language_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/notification_settings_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/theme_screen.dart';
import 'package:waterbus/gen/assets.gen.dart';
import 'package:waterbus_sdk/types/index.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extension.dart';

final GlobalKey<SlidingDrawerState> sideMenuKey =
    GlobalKey<SlidingDrawerState>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentTab = Strings.recent;

  void _handleToggleDrawer() {
    if (context.isDesktop) return;

    sideMenuKey.toggle();
  }

  Widget _getCurrentTab() {
    switch (_currentTab) {
      case Strings.recent:
        return const RecentMeetings();
      case Strings.chat:
        return const ChatsScreen();
      case Strings.notifications:
        return const NotificationSettingsScreen();
      case Strings.appearance:
        return const ThemeScreen(isSettingDesktop: true);
      case Strings.archivedChats:
        return const ArchivedScreen();
      case Strings.language:
        return const LanguageScreen(isSettingDesktop: true);
      case Strings.callSettings:
        return const CallSettingsScreen(isSettingDesktop: true);
      case Strings.licenses:
        return LicensePage(
          applicationIcon: Image.asset(
            Assets.icons.launcherIcon.path,
            height: 35.sp,
          ),
          applicationVersion: kAppVersion,
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlidingDrawer(
      key: sideMenuKey,
      drawerBuilder: (_) => _buildDrawable(),
      contentBuilder: (_) => Scaffold(
        appBar: appBarTitleBack(
          context,
          centerTitle: false,
          isVisibleBackButton: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          titleWidget: sideMenuKey.currentState?.isOpen ?? false
              ? null
              : BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserDone) {
                      final User user = state.user;

                      return Row(
                        children: [
                          SizedBox(width: 6.sp),
                          GestureDetector(
                            onTap: _handleToggleDrawer,
                            child: AvatarCard(
                              urlToImage: user.avatar,
                              size: 30.sp,
                              label: user.fullName,
                            ),
                          ),
                          SizedBox(width: 10.sp),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user.fullName,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Text(
                                '@${user.userName}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 10.sp,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }

                    return const SizedBox();
                  },
                ),
          actions: [
            buildCreateMeetingButton(context, _currentTab),
          ],
        ),
        body: Row(
          children: [
            Expanded(
              child: ColoredBox(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  children: [
                    buildHeader(context, _currentTab),
                    Expanded(child: _getCurrentTab()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawable() {
    return ProfileDrawerLayout(
      onTapItem: (item) {
        _handleToggleDrawer();

        Future.delayed(300.milliseconds, () {
          switch (item.title) {
            case Strings.logout:
              displayLoadingLayer();
              AppBloc.authBloc.add(AuthLoggedOut());
              break;
            case Strings.profile:
              context.push(Routes.profileRoute);
              break;
            case Strings.archivedChats:
              context.push(Routes.archivedRoute);
              break;
            case Strings.settings:
              context.push(Routes.settingsCallRoute);
              break;
            case Strings.licenses:
              if (!mounted) return;

              showLicensePage(
                context: context,
                applicationIcon: Image.asset(
                  Assets.icons.launcherIcon.path,
                  height: 35.sp,
                ),
                applicationVersion: kAppVersion,
              );
              break;
            default:
              break;
          }
        });
      },
    );
  }
}

Widget buildHeader(BuildContext context, String route) {
  final margin = EdgeInsets.only(
    top: 10.sp,
    bottom: 12.sp,
    left: context.isDesktop ? 0 : 10.sp,
    right: 10.sp,
  );

  switch (route) {
    case Strings.recent:
      return EnterCodeBox(
        margin: margin,
        hintTextContent: Strings.enterCodeToJoinMeeting.i18n,
        suffixWidget:
            context.isDesktop ? buildCreateMeetingButton(context, route) : null,
        onTap: () {
          context.push(Routes.enterCodeRoute);
        },
      );
    case Strings.archivedChats:
      return EnterCodeBox(
        margin: margin,
        hintTextContent: Strings.search.i18n,
        onTap: () {},
      );
    case Strings.chat:
      return EnterCodeBox(
        margin: margin,
        hintTextContent: Strings.search.i18n,
        suffixWidget: buildCreateMeetingButton(context, route),
        onTap: () {},
      );
    default:
      return SizedBox(height: 10.sp);
  }
}

Widget buildCreateMeetingButton(BuildContext context, String route) {
  return GestureWrapper(
    onTap: () async {
      if (route == Strings.chat) {
        context.push(
          Routes.createMeetingRoute,
          extra: {'isChatScreen ': route == Strings.chat},
        );
      } else {
        await WaterbusPermissionHandler().checkGrantedForExecute(
          permissions: [Permission.camera, Permission.microphone],
          callBack: () async {
            context.push(Routes.createMeetingRoute);
          },
        );
      }
    },
    child: Container(
      width: 36.sp,
      height: 36.sp,
      margin: EdgeInsets.only(right: 16.sp),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.centerRight,
      child: Image.asset(
        Assets.icons.icNewMeeting.path,
        height: 22.sp,
        fit: BoxFit.fitHeight,
      ),
    ),
  );
}

class HomePage extends StatefulWidget {
  final GlobalKey<SlidingDrawerState> sideMenuKey;
  final Widget child;

  const HomePage({
    super.key,
    required this.sideMenuKey,
    required this.child,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentTab = Strings.recent;
  @override
  Widget build(BuildContext context) {
    return SlidingDrawer(
      key: widget.sideMenuKey,
      ignorePointer: context.isDesktop,
      drawerBuilder: (_) => const SizedBox(),
      contentBuilder: (_) => Scaffold(
        body: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.sp),
              color: Theme.of(context).colorScheme.outlineVariant,
              child: Material(
                shape: SuperellipseShape(
                  borderRadius: BorderRadius.circular(25.sp),
                ),
                clipBehavior: Clip.hardEdge,
                child: SideMenuWidget(
                  onTabChanged: (tabLabel) {
                    setState(() {
                      _currentTab = tabLabel;
                    });
                    if (AppRouter.homeContext == null) return;

                    switch (tabLabel) {
                      case Strings.recent:
                        return RecentHomeRoute().go(context);
                      case Strings.chat:
                        return ChatHomeRoute().go(context);
                      case Strings.notifications:
                        return NotificationSettingsHomeRoute().go(context);
                      case Strings.appearance:
                        return AppRouter.homeContext!.goNamed(
                          Routes.home + Routes.themeRoute,
                          extra: {'isSettingDesktop': true},
                        );
                      case Strings.archivedChats:
                        return AppRouter.homeContext!.goNamed(
                          Routes.home + Routes.archivedRoute,
                        );
                      case Strings.language:
                        return AppRouter.homeContext!.goNamed(
                          Routes.home + Routes.langRoute,
                          extra: {'isSettingDesktop': true},
                        );
                      case Strings.callSettings:
                        return AppRouter.homeContext!.goNamed(
                          Routes.home + Routes.settingsCallRoute,
                          extra: {'isSettingDesktop': true},
                        );

                      case Strings.licenses:
                        return LicenseHomeRoute().go(context);

                      default:
                        return;
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: ColoredBox(
                color: context.isDesktop
                    ? Theme.of(context).colorScheme.outlineVariant
                    : Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  children: [
                    buildHeader(context, _currentTab),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10.sp, right: 10.sp),
                        child: Material(
                          shape: SuperellipseShape(
                            borderRadius: BorderRadius.circular(25.sp),
                          ),
                          clipBehavior: Clip.hardEdge,
                          color:
                              Theme.of(context).colorScheme.surfaceContainerLow,
                          child: widget.child,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
