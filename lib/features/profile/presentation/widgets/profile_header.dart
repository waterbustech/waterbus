import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';
import 'package:waterbus/features/settings/presentation/bloc/themes/themes_bloc.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemesBloc, ThemesState>(
      builder: (context, stateTheme) {
        return BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            final User user = state is UserDone ? state.user : kUserDefault;

            return Container(
              padding: EdgeInsets.only(
                left: 20.sp,
                top: context.isDesktop ? 20.sp : 4.sp,
                bottom: 16.sp,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AvatarCard(
                    urlToImage: user.avatar,
                    size: context.isDesktop ? 35.sp : 30.sp,
                    label: user.fullName,
                  ),
                  SizedBox(height: 6.sp),
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
