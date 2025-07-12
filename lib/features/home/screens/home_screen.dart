// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sliding_drawer/flutter_sliding_drawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:waterbus_sdk/types/index.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extension.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/navigator/routes.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/core/utils/permission_handler.dart';
import 'package:waterbus/core/utils/platform_utils.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/archived/presentation/screens/archived_screen.dart';
import 'package:waterbus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waterbus/features/common/widgets/app_bar_title_back.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/home/screens/home_desktop_screen.dart';
import 'package:waterbus/features/home/widgets/enter_code_box.dart';
import 'package:waterbus/features/home/widgets/recent_meetings.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/profile/presentation/screens/profile_screen.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';
import 'package:waterbus/features/profile/presentation/widgets/profile_drawer_layout.dart';
import 'package:waterbus/features/room/presentation/screens/enter_meeting_code_screen.dart';
import 'package:waterbus/features/room/presentation/screens/meeting_form_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/call_settings_screen.dart';
import 'package:waterbus/gen/assets.gen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<SlidingDrawerState> sideMenuKey =
      GlobalKey<SlidingDrawerState>();

  void _handleToggleDrawer() {
    if (context.isDesktop) return;

    sideMenuKey.toggle();
  }

  @override
  Widget build(BuildContext context) {
    return context.isDesktop
        ? HomeDesktopScreen(header: _buildHeader)
        : SlidingDrawer(
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
                  buildCreateMeetingButton(context, Strings.recent),
                ],
              ),
              body: ColoredBox(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  children: [
                    _buildHeader(context, Strings.recent),
                    Expanded(child: RecentMeetings()),
                  ],
                ),
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
              if (PlatformUtils.isMobile) {
                ProfileRoute().push(context);
              } else {
                showScreenAsDialog(
                  route: Routes.profileRoute,
                  child: ProfileScreen(),
                );
              }
              break;
            case Strings.archivedChats:
              if (PlatformUtils.isMobile) {
                ArchivedRoute().push(context);
              } else {
                showScreenAsDialog(
                  route: Routes.archivedRoute,
                  child: ArchivedScreen(),
                );
              }
              break;
            case Strings.settings:
              if (PlatformUtils.isMobile) {
                CallSettingsRoute().push(context);
              } else {
                showScreenAsDialog(
                  route: Routes.callSettingsRoute,
                  child: CallSettingsScreen(isInRoom: false),
                );
              }
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

Widget _buildHeader(BuildContext context, String route) {
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
          if (context.isMobile) {
            EnterCodeRoute().push(context);
          } else {
            showScreenAsDialog(
              route: Routes.enterCodeRoute,
              child: EnterMeetingCode(),
            );
          }
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
        if (context.isMobile) {
          NewRoomRoute(isChatScreen: route == Strings.chat).push(context);
        } else {
          showScreenAsDialog(
            route: Routes.updateRoomRoute,
            child: MeetingFormScreen(
              isChatScreen: route == Strings.chat,
            ),
          );
        }
      } else {
        await WaterbusPermissionHandler().checkGrantedForExecute(
          permissions: [Permission.camera, Permission.microphone],
          callBack: () async {
            if (context.isMobile) {
              NewRoomRoute().push(context);
            } else {
              showScreenAsDialog(
                route: Routes.updateRoomRoute,
                child: MeetingFormScreen(),
              );
            }
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
