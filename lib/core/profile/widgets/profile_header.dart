import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/utils/cached_network_image/cached_network_image.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomNetworkImage(
              height: 26.sp,
              width: 26.sp,
              urlToImage:
                  'https://avatars.githubusercontent.com/u/60530946?v=4',
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
          "Kai Dao",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(
          "Senior at Waterbus",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 10.sp,
              ),
        ),
      ],
    );
  }
}
