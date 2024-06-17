import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/types/models/user_model.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/common/widgets/images/waterbus_image_picker.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';
import 'package:waterbus/features/settings/lang/language_service.dart';
import 'package:waterbus/features/settings/presentation/widgets/setting_row_button.dart';
import 'package:waterbus/gen/assets.gen.dart';

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
            top: SizerUtil.isDesktop ? 12.sp : 0,
            bottom: SizerUtil.isDesktop ? 20.sp : 75.sp,
          ),
        ),
        child: Column(
          children: [
            BlocBuilder<UserBloc, UserState>(
              buildWhen: (previous, current) => current is! UserSearchingState,
              builder: (context, state) {
                final User? user = state is UserGetDone ? state.user : null;

                return SizerUtil.isDesktop
                    ? GestureWrapper(
                        onTap: () {
                          if (SizerUtil.isDesktop) {
                            onTap?.call(profileTab);
                          } else {
                            AppNavigator().push(Routes.profileRoute);
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
                                          UpdateAvatarEvent(image: image),
                                        );
                                      },
                                    );
                                  },
                                  child: user?.avatar == null
                                      ? CircleAvatar(
                                          radius: 30.sp,
                                          backgroundColor: Colors.black,
                                          backgroundImage: AssetImage(
                                            Assets.images.imgAppLogo.path,
                                          ),
                                        )
                                      : AvatarCard(
                                          urlToImage: user?.avatar,
                                          size: 50.sp,
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
                                    PhosphorIcons.caret_right,
                                    color: colorGray3,
                                    size: SizerUtil.isDesktop ? 14.sp : null,
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
                                      UpdateAvatarEvent(image: image),
                                    );
                                  },
                                );
                              },
                              child: user?.avatar == null
                                  ? CircleAvatar(
                                      radius: 35.sp,
                                      backgroundColor: Colors.black,
                                      backgroundImage: AssetImage(
                                        Assets.images.imgAppLogo.path,
                                      ),
                                    )
                                  : AvatarCard(
                                      urlToImage: user?.avatar,
                                      size: 70.sp,
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
            if (!SizerUtil.isDesktop) ...[
              SettingRowButton(
                onTap: () {
                  AppNavigator().push(Routes.profileRoute);
                },
                title: Strings.myProfile.i18n,
                icon: PhosphorIcons.user_circle_fill,
                iconBackground: colorRedCustom,
              ),
              SizedBox(height: 18.sp),
            ],
            SettingRowButton(
              onTap: () {},
              title: Strings.notifications.i18n,
              isLast: false,
              icon: PhosphorIcons.bell_fill,
              iconBackground: colorRedOrange,
            ),
            SettingRowButton(
              onTap: () {
                if (SizerUtil.isDesktop) {
                  onTap?.call(appearanceTab);
                } else {
                  AppNavigator().push(Routes.themeRoute);
                }
              },
              isLast: false,
              isFirst: false,
              title: Strings.appearance.i18n,
              icon: PhosphorIcons.circle_half_fill,
              iconBackground: colorCyan,
            ),
            SettingRowButton(
              onTap: () {
                if (SizerUtil.isDesktop) {
                  onTap?.call(languageTab);
                } else {
                  AppNavigator().push(Routes.langRoute);
                }
              },
              title: Strings.language.i18n,
              isFirst: false,
              value: LanguageService().getLocale().base,
              icon: PhosphorIcons.globe,
              iconBackground: colorPurple,
            ),
            SizedBox(height: 18.sp),
            SettingRowButton(
              onTap: () {
                if (SizerUtil.isDesktop) {
                  onTap?.call(callAndMeetingTab);
                } else {
                  AppNavigator().push(Routes.settingsCallRoute);
                }
              },
              title: Strings.callAndMeeting.i18n,
              icon: PhosphorIcons.video_camera_fill,
              iconBackground: colorActive,
            ),
            SizedBox(height: 18.sp),
            SettingRowButton(
              onTap: () {},
              isLast: false,
              title: Strings.serverConfiguration.i18n,
              icon: PhosphorIcons.hard_drives_fill,
              iconBackground: Colors.deepOrange,
            ),
            SettingRowButton(
              onTap: () {},
              isFirst: false,
              isLast: false,
              title: Strings.clearCache.i18n,
              icon: PhosphorIcons.database_fill,
              iconBackground: Colors.indigoAccent,
            ),
            SettingRowButton(
              onTap: () {},
              isFirst: false,
              title: 'Waterbus ${Strings.version.i18n}',
              value: 'v1.1.3',
              icon: PhosphorIcons.desktop_fill,
              iconBackground: colorCyan,
            ),
          ],
        ),
      ),
    );
  }
}
