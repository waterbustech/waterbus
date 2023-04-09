// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/utils/cached_network_image/cached_network_image.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp).add(
        EdgeInsets.only(top: 12.sp),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomNetworkImage(
                  height: 35.sp,
                  width: 35.sp,
                  urlToImage:
                      'https://avatars.githubusercontent.com/u/60530946?v=4',
                ),
                SizedBox(width: 10.sp),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Kai Dao",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      "Senior at Askany",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 10.5.sp,
                          ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 36.sp,
            height: 36.sp,
            decoration: const BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.centerRight,
            child: Icon(
              PhosphorIcons.sun,
              color: Theme.of(context).primaryColor,
              size: 22.sp,
            ),
          ),
        ],
      ),
    );
  }
}
