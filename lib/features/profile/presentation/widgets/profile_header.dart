// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
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

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AvatarCard(
                      urlToImage: user.avatar,
                      size: 26.sp,
                    ),
                    IconButton(
                      onPressed: () {
                        AppBloc.themesBloc
                            .add(OnChangeTheme(appTheme: stateTheme.props[0]));
                      },
                      icon: stateTheme.props[0] == ThemeList.dark
                          ? Icon(
                              PhosphorIcons.moon_stars_fill,
                              color: Theme.of(context).primaryColor,
                            )
                          : Icon(
                              PhosphorIcons.sun_fill,
                              color: Theme.of(context).primaryColor,
                            ),
                    ),
                  ],
                ),
                SizedBox(height: 12.sp),
                Text(
                  user.fullName,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '@${user.userName}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 10.sp,
                      ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
