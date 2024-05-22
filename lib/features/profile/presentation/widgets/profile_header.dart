import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/themes/theme_model.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';
import 'package:waterbus/features/settings/themes/bloc/themes_bloc.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemesBloc, ThemesState>(
      builder: (context, stateTheme) {
        return BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            final User user = state is UserGetDone ? state.user : kUserDefault;

            return Container(
              padding: EdgeInsets.only(
                left: 20.sp,
                top: SizerUtil.isDesktop ? 20.sp : 0,
                bottom: 16.sp,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AvatarCard(
                        urlToImage: user.avatar,
                        size: SizerUtil.isDesktop ? 35.sp : 30.sp,
                      ),
                      IconButton(
                        onPressed: () {
                          AppBloc.themesBloc.add(
                            OnChangeTheme(
                              appTheme: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? ThemeList.dark
                                  : ThemeList.light,
                            ),
                          );
                        },
                        icon: Icon(
                          Theme.of(context).brightness == Brightness.dark
                              ? PhosphorIcons.sun_fill
                              : PhosphorIcons.moon_stars_fill,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.sp),
                  Text(
                    user.fullName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    '@${user.userName}',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontSize: 12.sp,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
