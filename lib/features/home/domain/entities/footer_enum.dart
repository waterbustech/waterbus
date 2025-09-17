import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waterbus/core/app/languages/localization.dart';
import 'package:waterbus/core/constants/color_constants.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/navigator/routes.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/core/utils/platform_utils.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waterbus/features/profile/presentation/screens/profile_screen.dart';

enum FooterAction {
  viewProfile,
  logout;

  String get label => switch (this) {
        FooterAction.viewProfile => Strings.viewPersonalInformation,
        FooterAction.logout => Strings.signOutOfYourAccount,
      };

  IconData get icon => switch (this) {
        FooterAction.viewProfile => LucideIcons.circleUserRound,
        FooterAction.logout => LucideIcons.logOut,
      };

  Color get color => switch (this) {
        FooterAction.viewProfile =>
          Theme.of(AppRouter.context!).colorScheme.secondary,
        FooterAction.logout => colorRedRemove,
      };

  Function() get function => switch (this) {
        FooterAction.viewProfile => () {
            if (PlatformUtils.isMobile) {
              ProfileRoute().push(AppRouter.context!);
            } else {
              showScreenAsDialog(
                route: Routes.profileRoute,
                child: ProfileScreen(),
              );
            }
          },
        FooterAction.logout => () {
            AppBloc.authBloc.add(AuthLoggedOut());
          },
      };
}
