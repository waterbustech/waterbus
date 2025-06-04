import 'package:flutter/material.dart';

import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/common/widgets/shimmers/fade_shimmer.dart';

class ShimmerUserCard extends StatelessWidget {
  const ShimmerUserCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.5.sp),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: FadeShimmer.round(
                    size: 32.sp,
                    fadeTheme: FadeTheme.lightReverse,
                  ),
                ),
                SizedBox(width: 8.sp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeShimmer(
                        height: 12.sp,
                        width: context.isDesktop ? 245.sp : 70.w,
                        fadeTheme: FadeTheme.lightReverse,
                      ),
                      SizedBox(height: 4.sp),
                      FadeShimmer(
                        height: 10.5.sp,
                        width: context.isDesktop ? 140.sp : 40.w,
                        fadeTheme: FadeTheme.lightReverse,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 52.5.sp).add(
              EdgeInsets.symmetric(vertical: 2.sp),
            ),
            child: divider,
          ),
        ],
      ),
    );
  }
}
