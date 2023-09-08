// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/utils/cached_network_image/cached_network_image.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/gen/assets.gen.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        final User user = state is UserGetDone && state.user != null
            ? state.user!
            : const User(
                id: 0,
                fullName: 'Waterbus',
                userName: 'waterbus.io',
                avatar: 'https://avatars.githubusercontent.com/u/60530946?v=4',
              );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                user.avatar == null
                    ? CircleAvatar(
                        radius: 13.sp,
                        backgroundColor: Colors.black,
                        backgroundImage: AssetImage(
                          Assets.images.imgAppLogo.path,
                        ),
                      )
                    : CustomNetworkImage(
                        height: 26.sp,
                        width: 26.sp,
                        urlToImage: user.avatar,
                      ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    PhosphorIcons.moon_stars_fill,
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
  }
}
