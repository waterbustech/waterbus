import 'package:flutter/material.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/settings/presentation/widgets/body_setting_screens.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: SizerUtil.isDesktop ? 300.sp : 100.w,
          child: Scaffold(
            appBar: appBarTitleBack(
              context,
              title: SizerUtil.isDesktop ? Strings.settings.i18n : '',
              leading: IconButton(
                padding: EdgeInsets.only(left: 12.sp),
                onPressed: () {},
                icon: Icon(
                  PhosphorIcons.userCirclePlus(),
                  color: Theme.of(context).colorScheme.primary,
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
                    padding: EdgeInsets.only(
                      right: SizerUtil.isDesktop ? 20.sp : 12.sp,
                    ),
                    child: Text(
                      Strings.edit.i18n,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: const BodySettingScreens(),
          ),
        ),
      ],
    );
  }
}
