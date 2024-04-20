import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/constants/constants.dart';
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
        leading: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            final User user = state is UserGetDone ? state.user : kUserDefault;

            return Align(
              alignment: Alignment.centerRight,
              child: AvatarCard(
                urlToImage: user.avatar,
                size: 24.sp,
              ),
            );
          },
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
                'Edit',
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
              title: 'My Profile',
              icon: Icons.account_circle_rounded,
              iconBackground: colorRedCustom,
            ),
            SizedBox(height: 18.sp),
            SettingRowButton(
              onTap: () {},
              isLast: false,
              title: 'Saved Messages',
              icon: Icons.bookmark,
              iconBackground: colorBlue,
            ),
            SettingRowButton(
              onTap: () {},
              isLast: false,
              isFirst: false,
              title: 'Appearance',
              icon: Icons.contrast_outlined,
              iconBackground: colorCyan,
            ),
            SettingRowButton(
              onTap: () {},
              title: 'Languages',
              isFirst: false,
              icon: Icons.language_outlined,
              iconBackground: colorPurple,
            ),
            SizedBox(height: 18.sp),
            SettingRowButton(
              onTap: () {
                AppNavigator().push(Routes.settingsCallRoute);
              },
              title: 'Call & Meeting',
              icon: Icons.video_call_outlined,
              iconBackground: colorActive,
            ),
          ],
        ),
      ),
    );
  }
}
