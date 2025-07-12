import 'package:flutter/material.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/navigator/routes.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/core/utils/platform_utils.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/profile/presentation/screens/profile_screen.dart';

class FooterPopoverBody extends StatelessWidget {
  const FooterPopoverBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.sp),
        _footerPopoverButton(
          context: context,
          icon: PhosphorIcons.userCircle(),
          color: Theme.of(context).colorScheme.secondary,
          title: Strings.viewPersonalInformation.i18n,
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
        ),
        _footerPopoverButton(
          context: context,
          icon: PhosphorIcons.signOut(),
          color: colorRedRemove,
          title: Strings.signOutOfYourAccount.i18n,
          onTap: () {
            AppBloc.authBloc.add(AuthLoggedOut());
          },
        ),
        SizedBox(height: 8.sp),
      ],
    );
  }

  GestureWrapper _footerPopoverButton({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required Function() onTap,
  }) {
    return GestureWrapper(
      onTap: () {
        AppRouter.pop();
        onTap.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.sp,
          vertical: 8.sp,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: color,
            ),
            SizedBox(width: 8.sp),
            Text(
              title,
              style: TextStyle(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
