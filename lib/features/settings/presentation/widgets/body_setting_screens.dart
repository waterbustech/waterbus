import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/navigator/routes.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/core/utils/platform_utils.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/common/widgets/images/waterbus_image_picker.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/profile/presentation/screens/profile_screen.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';
import 'package:waterbus/features/settings/lang/language_service.dart';
import 'package:waterbus/features/settings/presentation/screens/call_settings_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/language_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/theme_screen.dart';
import 'package:waterbus/features/settings/presentation/widgets/setting_row_button.dart';

class BodySettingScreens extends StatelessWidget {
  final Function(String)? onTap;

  const BodySettingScreens({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.sp).add(
          EdgeInsets.only(
            top: context.isDesktop ? 12.sp : 0,
            bottom: context.isDesktop ? 20.sp : 75.sp,
          ),
        ),
        child: Column(
          children: [
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                final User? user = state is UserDone ? state.user : null;

                return context.isDesktop
                    ? GestureWrapper(
                        onTap: () {
                          if (context.isDesktop) {
                            onTap?.call(profileTab);
                          } else {
                            if (PlatformUtils.isMobile) {
                              ProfileRoute().push(context);
                            } else {
                              showScreenAsDialog(
                                route: Routes.profileRoute,
                                child: ProfileScreen(),
                              );
                            }
                          }
                        },
                        child: Material(
                          clipBehavior: Clip.hardEdge,
                          shape: SuperellipseShape(
                            borderRadius: BorderRadius.circular(25.sp),
                          ),
                          color: Theme.of(context).colorScheme.onInverseSurface,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.sp,
                              vertical: 10.sp,
                            ),
                            child: Row(
                              children: [
                                GestureWrapper(
                                  onTap: () {
                                    WaterbusImagePicker().openImagePicker(
                                      context: context,
                                      handleFinish: (image) {
                                        displayLoadingLayer();

                                        AppBloc.userBloc.add(
                                          UserAvatarUpdated(image: image),
                                        );
                                      },
                                    );
                                  },
                                  child: AvatarCard(
                                    urlToImage: user?.avatar,
                                    size: 50.sp,
                                    label: user?.fullName,
                                  ),
                                ),
                                SizedBox(width: 8.sp),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 6.sp),
                                        child: Text(
                                          user?.fullName ?? "",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .color,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "@${user?.userName ?? ""}",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 6.sp),
                                  child: Icon(
                                    PhosphorIcons.caretRight(),
                                    color: colorGray3,
                                    size: context.isDesktop ? 14.sp : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Align(
                            child: GestureWrapper(
                              onTap: () {
                                WaterbusImagePicker().openImagePicker(
                                  context: context,
                                  handleFinish: (image) {
                                    displayLoadingLayer();

                                    AppBloc.userBloc.add(
                                      UserAvatarUpdated(image: image),
                                    );
                                  },
                                );
                              },
                              child: AvatarCard(
                                urlToImage: user?.avatar,
                                size: 70.sp,
                                label: user?.fullName,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 6.sp, bottom: 2.sp),
                            child: Text(
                              user?.fullName ?? "",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color,
                              ),
                            ),
                          ),
                          Text(
                            "@${user?.userName ?? ""}",
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color:
                                  Theme.of(context).textTheme.titleSmall!.color,
                            ),
                          ),
                        ],
                      );
              },
            ),
            SizedBox(height: 20.sp),
            if (context.isMobile) ...[
              SettingRowButton(
                onTap: () {
                  if (PlatformUtils.isMobile) {
                    ProfileRoute().push(context);
                  } else {
                    showScreenAsDialog(
                      route: Routes.profileRoute,
                      child: ProfileScreen(),
                    );
                  }
                },
                title: Strings.myProfile.i18n,
                icon: PhosphorIcons.userCircle(PhosphorIconsStyle.fill),
                iconBackground: colorRedCustom,
              ),
              SizedBox(height: 18.sp),
            ],
            SettingRowButton(
              onTap: () {
                NotificationSettingsRoute().push(context);
              },
              title: Strings.notifications.i18n,
              isLast: false,
              icon: PhosphorIcons.bell(PhosphorIconsStyle.fill),
              iconBackground: colorRedOrange,
            ),
            SettingRowButton(
              onTap: () {
                if (context.isDesktop) {
                  onTap?.call(appearanceTab);
                } else {
                  if (PlatformUtils.isMobile) {
                    ThemeRoute().push(context);
                  } else {
                    showScreenAsDialog(
                      route: Routes.themeRoute,
                      child: ThemeScreen(),
                    );
                  }
                }
              },
              isLast: false,
              isFirst: false,
              title: Strings.appearance.i18n,
              icon: PhosphorIcons.circleHalf(PhosphorIconsStyle.fill),
              iconBackground: colorCyan,
            ),
            SettingRowButton(
              onTap: () {
                if (context.isDesktop) {
                  onTap?.call(languageTab);
                } else {
                  if (PlatformUtils.isMobile) {
                    LangRoute().push(context);
                  } else {
                    showScreenAsDialog(
                      route: Routes.langRoute,
                      child: LanguageScreen(),
                    );
                  }
                }
              },
              title: Strings.language.i18n,
              isFirst: false,
              value: LanguageService().getLocale().base,
              icon: PhosphorIcons.globe(),
              iconBackground: colorPurple,
            ),
            SizedBox(height: 18.sp),
            SettingRowButton(
              onTap: () {
                if (context.isDesktop) {
                  onTap?.call(callAndMeetingTab);
                } else {
                  if (PlatformUtils.isMobile) {
                    CallSettingsRoute().push(context);
                  } else {
                    showScreenAsDialog(
                      route: Routes.callSettingsRoute,
                      child: CallSettingsScreen(isInRoom: false),
                    );
                  }
                }
              },
              title: Strings.callAndMeeting.i18n,
              icon: PhosphorIcons.videoCamera(PhosphorIconsStyle.fill),
              iconBackground: colorActive,
            ),
            SizedBox(height: 18.sp),
            SettingRowButton(
              onTap: () {},
              isLast: false,
              title: Strings.serverConfiguration.i18n,
              icon: PhosphorIcons.hardDrives(PhosphorIconsStyle.fill),
              iconBackground: Colors.deepOrange,
            ),
            SettingRowButton(
              onTap: () {},
              isFirst: false,
              isLast: false,
              title: Strings.clearCache.i18n,
              icon: PhosphorIcons.database(PhosphorIconsStyle.fill),
              iconBackground: Colors.indigoAccent,
            ),
            SettingRowButton(
              onTap: () {},
              isFirst: false,
              title: 'Waterbus ${Strings.version.i18n}',
              value: kAppVersion,
              icon: PhosphorIcons.desktop(PhosphorIconsStyle.fill),
              iconBackground: colorCyan,
            ),
          ],
        ),
      ),
    );
  }
}
