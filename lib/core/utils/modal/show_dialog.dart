import 'package:flutter/material.dart';

import 'package:superellipse_shape/superellipse_shape.dart';

import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/types/slide.dart';
import 'package:waterbus/core/utils/modal/show_bottom_sheet.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';

Future showDialogWaterbus({
  Slide slideFrom = Slide.bot,
  required Widget child,
  int duration = 300,
  double paddingTop = 0.0,
  double paddingBottom = 0.0,
  Color? backgroundColor,
  double paddingHorizontal = 15.0,
  double borderRadius = 40.0,
  bool dismissible = true,
  Color? barrierColor,
  int? dismissionDuration,
  double maxHeight = double.infinity,
  double? maxWidth,
  bool onlyShowAsDialog = false,
  AlignmentGeometry? alignment,
}) async {
  final BuildContext context = AppRouter.context!;

  if (context.isMobile && !onlyShowAsDialog) {
    return showBottomSheetWaterbus(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            if (FocusManager.instance.primaryFocus?.hasFocus ?? false) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: child,
        );
      },
    );
  }

  var beginOffset = const Offset(-1, 0);
  switch (slideFrom) {
    case Slide.left:
      beginOffset = const Offset(-1, 0);
      break;
    case Slide.right:
      beginOffset = const Offset(1, 0);
      break;
    case Slide.top:
      beginOffset = const Offset(0, -1);
      break;
    default:
      beginOffset = const Offset(0, 1);
      break;
  }

  return await showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: dismissible,
    transitionDuration: Duration(milliseconds: duration),
    context: AppRouter.context!,
    pageBuilder: (context, __, ___) {
      return Dialog(
        alignment: alignment,
        shape: SuperellipseShape(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        insetPadding: EdgeInsets.only(
          left: paddingHorizontal,
          right: paddingHorizontal,
          top: paddingTop,
          bottom: paddingBottom,
        ),
        backgroundColor: backgroundColor ??
            Theme.of(AppRouter.context!).dialogTheme.backgroundColor,
        child: PopScope(
          canPop: dismissible,
          child: GestureDetector(
            onTap: () {
              if (FocusManager.instance.primaryFocus?.hasFocus ?? false) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            child: Container(
              constraints: BoxConstraints(
                maxHeight: maxHeight,
                maxWidth: maxWidth ?? 330.sp,
              ),
              child: child,
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: beginOffset, end: Offset.zero).animate(anim),
        child: child,
      );
    },
  );
}

Future showScreenAsDialog({
  required String route,
  required Widget child,
}) {
  return showDialogWaterbus(
    duration: 200,
    maxHeight: 100.h,
    maxWidth: 400.sp,
    barrierColor: Colors.transparent,
    borderRadius: 16.sp,
    child: Material(
      clipBehavior: Clip.hardEdge,
      shape: SuperellipseShape(
        borderRadius: BorderRadius.circular(16.sp),
      ),
      child: SizedBox(
        height: !AppRouter.context!.isLandscape ? 80.h : 90.h,
        child: child,
      ),
    ),
  );
}
