import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sliding_drawer/flutter_sliding_drawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus/features/home/widgets/home_app.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/core/utils/permission_handler.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/archived/presentation/screens/archived_screen.dart';
import 'package:waterbus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waterbus/features/chats/presentation/screens/chats_screen.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/home/widgets/enter_code_box.dart';
import 'package:waterbus/features/home/widgets/recent_meetings.dart';
import 'package:waterbus/features/home/widgets/side_menu_widget.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';
import 'package:waterbus/features/profile/presentation/widgets/profile_drawer_layout.dart';
import 'package:waterbus/features/record/screens/record_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/call_settings_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/language_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/notification_settings_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/theme_screen.dart';
import 'package:waterbus/gen/assets.gen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<SlidingDrawerState> _sideMenuKey =
      GlobalKey<SlidingDrawerState>();

  String _currentTab = Strings.recent;

  void _handleToggleDrawer() {
    if (SizerUtil.isDesktop) return;

    _sideMenuKey.toggle();
  }

  Widget _getCurrentTab() {
    switch (_currentTab) {
      case Strings.recent:
        return const RecentMeetings();
      case Strings.chat:
        return const ChatsScreen();
      case Strings.storage:
        return const RecordScreen();
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
            Assets.images.imgLogo.path,
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
      key: _sideMenuKey,
      ignorePointer: SizerUtil.isDesktop,
      drawerBuilder: (_) =>
          SizerUtil.isDesktop ? const SizedBox() : _buildDrawable(),
      contentBuilder: (_) => Scaffold(
        appBar: SizerUtil.isDesktop
            ? null
            : appBarTitleBack(
                context,
                centerTitle: false,
                isVisibleBackButton: false,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                titleWidget: BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserGetDone) {
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
                actions: [_buildCreateMeetingButton],
              ),
        body: Row(
          children: [
            if (SizerUtil.isDesktop)
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
                      AppNavigator.popUntilHomeContext();

                      setState(() {
                        _currentTab = tabLabel;
                      });
                    },
                  ),
                ),
              ),
            Expanded(
              child: ColoredBox(
                color: SizerUtil.isDesktop
                    ? Theme.of(context).colorScheme.outlineVariant
                    : Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  children: [
                    _buildHeader(context),
                    Expanded(
                      child: SizerUtil.isDesktop
                          ? Container(
                              margin:
                                  EdgeInsets.only(bottom: 10.sp, right: 10.sp),
                              child: Material(
                                shape: SuperellipseShape(
                                  borderRadius: BorderRadius.circular(25.sp),
                                ),
                                clipBehavior: Clip.hardEdge,
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerLow,
                                child:
                                    HomeAppScreen(homeScreen: _getCurrentTab()),
                              ),
                            )
                          : _getCurrentTab(),
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

  Widget _buildDrawable() {
    return ProfileDrawerLayout(
      onTapItem: (item) {
        _handleToggleDrawer();

        Future.delayed(const Duration(milliseconds: 300), () {
          switch (item.title) {
            case Strings.logout:
              displayLoadingLayer();
              AppBloc.authBloc.add(LogOutEvent());
              break;
            case Strings.profile:
              AppNavigator().push(Routes.profileRoute);
              break;
            case Strings.archivedChats:
              AppNavigator().push(Routes.archivedRoute);
              break;
            case Strings.storage:
              AppNavigator().push(Routes.storage);
              break;
            case Strings.settings:
              AppNavigator().push(Routes.settingsCallRoute);
              break;
            case Strings.licenses:
              if (!mounted) return;

              showLicensePage(
                context: context,
                applicationIcon: Image.asset(
                  Assets.images.imgLogo.path,
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

  Widget _buildHeader(BuildContext context) {
    final margin = EdgeInsets.only(
      top: 10.sp,
      bottom: 12.sp,
      left: SizerUtil.isDesktop ? 0 : 10.sp,
      right: SizerUtil.isDesktop ? 0 : 10.sp,
    );

    switch (_currentTab) {
      case Strings.recent:
        return EnterCodeBox(
          margin: margin,
          hintTextContent: Strings.enterCodeToJoinMeeting.i18n,
          suffixWidget: SizerUtil.isDesktop ? _buildCreateMeetingButton : null,
          onTap: () {
            AppNavigator().push(Routes.enterCodeRoute);
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
          suffixWidget: _buildCreateMeetingButton,
          onTap: () {},
        );
      default:
        return SizedBox(height: 10.sp);
    }
  }

  Widget get _buildCreateMeetingButton {
    return GestureWrapper(
      onTap: () async {
        if (_currentTab == Strings.chat) {
          AppNavigator().push(
            Routes.createMeetingRoute,
            arguments: {
              'isChatScreen': _currentTab == Strings.chat,
            },
          );
        } else {
          await WaterbusPermissionHandler().checkGrantedForExecute(
            permissions: [Permission.camera, Permission.microphone],
            callBack: () async {
              AppNavigator().push(Routes.createMeetingRoute);
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
}
