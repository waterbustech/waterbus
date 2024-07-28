import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'package:waterbus/core/utils/shimmers/fade_shimmer.dart';
import 'package:waterbus/features/common/styles/style.dart';

class ShimmerInvitedChatCard extends StatelessWidget {
  const ShimmerInvitedChatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.sp),
          child: Row(
            children: [
              FadeShimmer.round(
                size: 38.sp,
                fadeTheme: FadeTheme.lightReverse,
              ),
              SizedBox(width: 4.sp),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeShimmer(
                        height: 12.sp,
                        width: 100.w,
                        fadeTheme: FadeTheme.lightReverse,
                      ),
                      SizedBox(height: 4.sp),
                      FadeShimmer(
                        height: 12.sp,
                        width: 40.w,
                        fadeTheme: FadeTheme.lightReverse,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 6.sp),
              FadeShimmer(
                height: 16.sp,
                width: 50.sp,
                fadeTheme: FadeTheme.lightReverse,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.sp)
              .add(EdgeInsets.only(left: 58.sp)),
          child: divider,
        ),
      ],
    );
  }
}
