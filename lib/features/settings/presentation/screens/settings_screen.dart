// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/data_languages.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/common/widgets/images/waterbus_image_picker.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';
import 'package:waterbus/features/settings/presentation/widgets/setting_row_button.dart';
import 'package:waterbus/gen/assets.gen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleBack(
        context,
        leading: IconButton(
          onPressed: () {
            AppNavigator().push(Routes.createMeetingRoute);
          },
          icon: Icon(
            PhosphorIcons.user_circle_plus,
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: [
          GestureWrapper(
            onTap: () {
              AppNavigator().push(Routes.profileRoute);
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              padding: EdgeInsets.all(12.sp),
              child: Text(
                Strings.edit.i18n,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.sp),
        child: Column(
          children: [
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                final User? user = state is UserGetDone ? state.user : null;

                return Column(
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
                                radius: 40.sp,
                                backgroundColor: Colors.black,
                                backgroundImage: AssetImage(
                                  Assets.images.imgAppLogo.path,
                                ),
                              )
                            : AvatarCard(
                                urlToImage: user?.avatar,
                                size: 80.sp,
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
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                    ),
                    Text(
                      "@${user?.userName ?? ""}",
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).textTheme.titleSmall!.color,
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 32.sp),
            SettingRowButton(
              onTap: () {
                AppNavigator().push(Routes.profileRoute);
              },
              title: Strings.myProfile.i18n,
              icon: PhosphorIcons.user_circle_fill,
              iconBackground: colorRedCustom,
            ),
            SizedBox(height: 18.sp),
            SettingRowButton(
              onTap: () {},
              title: Strings.notifications.i18n,
              isLast: false,
              icon: PhosphorIcons.bell_fill,
              iconBackground: colorRedOrange,
            ),
            SettingRowButton(
              onTap: () {
                AppNavigator().push(Routes.themeRoute);
              },
              isLast: false,
              isFirst: false,
              title: Strings.appearance.i18n,
              icon: PhosphorIcons.circle_half_fill,
              iconBackground: colorCyan,
            ),
            SettingRowButton(
              onTap: () {
                AppNavigator().push(Routes.langRoute);
              },
              title: Strings.language.i18n,
              isFirst: false,
              icon: PhosphorIcons.globe,
              iconBackground: colorPurple,
            ),
            SizedBox(height: 18.sp),
            SettingRowButton(
              onTap: () {
                AppNavigator().push(Routes.settingsCallRoute);
              },
              title: Strings.callAndMeeting.i18n,
              icon: PhosphorIcons.video_camera_fill,
              iconBackground: colorActive,
            ),
          ],
        ),
      ),
    );
  }
}
