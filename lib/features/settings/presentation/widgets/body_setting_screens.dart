import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/languages/localization.dart';
import 'package:waterbus/core/constants/color_constants.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/extensions/context_extensions.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/navigator/routes.dart';
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
import 'package:waterbus/features/settings/data/repositories/language_repository.dart';
import 'package:waterbus/features/settings/presentation/widgets/setting_row_button.dart';

class BodySettingScreens extends StatelessWidget {
  const BodySettingScreens({super.key});

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
                icon: LucideIcons.circleUser,
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
              icon: LucideIcons.bell,
              iconBackground: colorRedOrange,
            ),
            SettingRowButton(
              onTap: () {
                ThemeRoute().push(context);
              },
              isLast: false,
              isFirst: false,
              title: Strings.appearance.i18n,
              icon: LucideIcons.paintbrush,
              iconBackground: colorCyan,
            ),
            SettingRowButton(
              onTap: () {
                LangRoute().push(context);
              },
              title: Strings.language.i18n,
              isFirst: false,
              value: LanguageRepositoryImpl().getLocale().base,
              icon: LucideIcons.globe,
              iconBackground: colorPurple,
            ),
            SizedBox(height: 18.sp),
            SettingRowButton(
              onTap: () {
                CallSettingsRoute().push(context);
              },
              title: Strings.callAndMeeting.i18n,
              icon: LucideIcons.video,
              iconBackground: colorActive,
            ),
            SizedBox(height: 18.sp),
            SettingRowButton(
              onTap: () {},
              isLast: false,
              title: Strings.serverConfiguration.i18n,
              icon: LucideIcons.terminal,
              iconBackground: Colors.deepOrange,
            ),
            SettingRowButton(
              onTap: () {},
              isFirst: false,
              title: 'Waterbus ${Strings.version.i18n}',
              value: kAppVersion,
              icon: LucideIcons.code,
              iconBackground: colorCyan,
            ),
          ],
        ),
      ),
    );
  }
}
