import 'package:flutter/material.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/navigator/routes.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/core/utils/platform_utils.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/common/widgets/app_bar_title_back.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/profile/presentation/screens/profile_screen.dart';
import 'package:waterbus/features/settings/presentation/widgets/body_setting_screens.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: context.isDesktop ? 300.sp : 100.w,
          child: Scaffold(
            appBar: appBarTitleBack(
              context,
              title: context.isDesktop ? Strings.settings.i18n : '',
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
                    if (PlatformUtils.isMobile) {
                      ProfileRoute().push(context);
                    } else {
                      showScreenAsDialog(
                        route: Routes.profileRoute,
                        child: ProfileScreen(),
                      );
                    }
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    padding: EdgeInsets.only(
                      right: context.isDesktop ? 20.sp : 12.sp,
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
