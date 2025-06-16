import 'package:flutter/material.dart';

import 'package:waterbus_sdk/utils/extensions/duration_extension.dart';

import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/chats/presentation/widgets/glass_morphism_wrapper.dart';

showSnackBarWaterbus({
  String? content,
  Widget? child,
}) {
  ScaffoldMessenger.of(AppRouter.context!).hideCurrentSnackBar();

  ScaffoldMessenger.of(AppRouter.context!).showSnackBar(
    SnackBar(
      width: AppRouter.context!.isDesktop ? 45.w : null,
      duration: 2000.milliseconds,
      dismissDirection: DismissDirection.horizontal,
      margin:
          AppRouter.context!.isDesktop ? null : EdgeInsets.only(bottom: 24.sp),
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
            color: Theme.of(AppRouter.context!)
                .colorScheme
                .surfaceContainer
                .withValues(alpha: 0.7),
          ),
          child: child ??
              Text(
                content ?? "",
                style: TextStyle(
                  color:
                      Theme.of(AppRouter.context!).textTheme.bodyMedium!.color,
                  fontSize: 10.sp,
                ),
              ),
        ),
      ),
    ),
  );
}
