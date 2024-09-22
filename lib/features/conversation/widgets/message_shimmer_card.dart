import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'package:waterbus/core/utils/shimmers/fade_shimmer.dart';

class MessageShimmerCard extends StatelessWidget {
  final bool isMe;
  final int numberOfRow;

  const MessageShimmerCard({
    super.key,
    required this.isMe,
    required this.numberOfRow,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        SizedBox(width: 10.sp),
        !isMe
            ? FadeShimmer.round(
                size: 20.sp,
                fadeTheme: FadeTheme.lightReverse,
              )
            : SizedBox(height: 20.sp, width: 20.sp),
        Container(
          margin: EdgeInsets.only(
            right: 12.sp,
            left: 8.sp,
            bottom: 16.sp,
          ),
          decoration: BoxDecoration(
            color: isMe
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10.sp),
          ),
          constraints:
              BoxConstraints(maxWidth: SizerUtil.isDesktop ? 45.w : 195.sp),
          padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeShimmer(
                width: 100.w,
                height: 12.sp,
                fadeTheme: FadeTheme.lightReverse,
              ),
              numberOfRow == 2 ? SizedBox(height: 8.sp) : Container(),
              numberOfRow == 2
                  ? FadeShimmer(
                      width: SizerUtil.isDesktop ? 25.w : 125.sp,
                      height: 12.sp,
                      highlightColor:
                          Theme.of(context).textTheme.bodyMedium!.color,
                      fadeTheme: FadeTheme.lightReverse,
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}
