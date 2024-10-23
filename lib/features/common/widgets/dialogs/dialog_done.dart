import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:waterbus/core/helpers/device_utils.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extensions.dart';

import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/gen/assets.gen.dart';

Future showDialogDone({
  required String text,
  bool dismissible = true,
  int? timeForDismiss = 1500,
}) {
  if (timeForDismiss != null) {
    Future.delayed(timeForDismiss.milliseconds, () {
      AppNavigator.pop();
    });
  }

  DeviceUtils().lightImpact();

  return showDialog(
    context: AppNavigator.context!,
    barrierColor: Colors.transparent,
    builder: (context) {
      return Material(
        color: Colors.transparent,
        child: SizedBox(
          height: 100.h,
          width: 100.w,
          child: Center(
            child: SizedBox(
              width: 135.sp,
              height: 135.sp,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 4.0,
                    sigmaY: 4.0,
                  ),
                  child: Container(
                    width: 115.sp,
                    height: 115.sp,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12.sp),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.icons.icCheck.path,
                          width: 50.sp,
                          height: 60.sp,
                          color: Theme.of(context).textTheme.labelMedium?.color,
                          fit: BoxFit.fitHeight,
                        ),
                        Text(
                          text,
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
