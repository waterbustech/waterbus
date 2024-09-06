import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extensions.dart';

import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/features/chats/presentation/widgets/glass_morphism_wrapper.dart';

showSnackBarWaterbus({
  String? content,
  Widget? child,
}) {
  ScaffoldMessenger.of(AppNavigator.context!).hideCurrentSnackBar();

  ScaffoldMessenger.of(AppNavigator.context!).showSnackBar(
    SnackBar(
      duration: 2000.milliseconds,
      dismissDirection: DismissDirection.horizontal,
      margin: EdgeInsets.only(bottom: 24.sp),
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: GlassmorphismWrapper(
        borderRadius: BorderRadius.circular(10.sp),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.sp,
            vertical: 8.sp,
          ),
          decoration: BoxDecoration(
            color: Theme.of(AppNavigator.context!)
                .colorScheme
                .surfaceContainer
                .withOpacity(0.7),
          ),
          child: child ??
              Text(
                content ?? "",
                style: TextStyle(
                  color: Theme.of(AppNavigator.context!)
                      .textTheme
                      .bodyMedium!
                      .color,
                  fontSize: 10.sp,
                ),
              ),
        ),
      ),
    ),
  );
}
