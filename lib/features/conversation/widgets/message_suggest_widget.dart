import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';

class MessageSuggestWidget extends StatelessWidget {
  final String image;

  const MessageSuggestWidget({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(16.sp),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: Theme.of(context).brightness == Brightness.dark ? 12 : 6,
          sigmaY: Theme.of(context).brightness == Brightness.dark ? 12 : 6,
        ),
        child: SizedBox(
          width: 200.sp,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.sp),
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainer
                      .withOpacity(0.7),
                ),
                margin: EdgeInsets.only(
                  bottom: SizerUtil.isDesktop
                      ? 200.sp
                      : MediaQuery.of(context).viewPadding.bottom == 0
                          ? 10.sp
                          : 165.sp,
                ),
                padding: EdgeInsets.all(12.sp),
                child: Column(
                  children: [
                    Text(
                      '${Strings.noMesssagesHereYet.i18n}...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 11.5.sp,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                    SizedBox(height: 2.sp),
                    Text(
                      Strings.sendMessageOrTapOnTheGreetingBelow.i18n,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                    Image.asset(image, width: 120.sp, height: 125.sp),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
