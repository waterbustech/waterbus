import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'package:waterbus/core/utils/shimmers/fade_shimmer.dart';
import 'package:waterbus/features/common/styles/style.dart';

class ShimmerChatCard extends StatelessWidget {
  const ShimmerChatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 5.sp,
            left: 18.5.sp,
            right: 16.sp,
            bottom: 5.sp,
          ),
          child: Row(
            children: [
              FadeShimmer.round(
                size: 38.sp,
                fadeTheme: FadeTheme.lightReverse,
              ),
              SizedBox(width: 10.sp),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 20.sp,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          FadeShimmer(
                            height: 12.sp,
                            width: SizerUtil.isDesktop ? 145.sp : 50.w,
                            fadeTheme: FadeTheme.lightReverse,
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              FadeShimmer(
                                height: 12.sp,
                                width: 12.sp,
                                fadeTheme: FadeTheme.lightReverse,
                              ),
                              SizedBox(width: 4.sp),
                              FadeShimmer(
                                height: 12.sp,
                                width: 28.sp,
                                fadeTheme: FadeTheme.lightReverse,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 20.sp,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          FadeShimmer(
                            height: 10.5.sp,
                            width: SizerUtil.isDesktop ? 100.sp : 30.w,
                            fadeTheme: FadeTheme.lightReverse,
                          ),
                          const Spacer(),
                          FadeShimmer.round(
                            size: 16.sp,
                            fadeTheme: FadeTheme.lightReverse,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: SizerUtil.isDesktop ? 74.sp : 66.sp,
          ),
          child: divider,
        ),
      ],
    );
  }
}
