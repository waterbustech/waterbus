import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/types/slide.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';

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
  String routeName = Routes.dialogRoute,
}) async {
  if (SizerUtil.isMobile && !onlyShowAsDialog) {
    return showModalBottomSheet(
      context: AppNavigator.context!,
      isScrollControlled: true,
      builder: (context) {
        return GestureWrapper(child: child);
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
    routeSettings: RouteSettings(name: routeName),
    barrierLabel: "Barrier",
    barrierDismissible: dismissible,
    transitionDuration: Duration(milliseconds: duration),
    context: AppNavigator.context!,
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
            Theme.of(AppNavigator.context!).dialogTheme.backgroundColor,
        child: PopScope(
          canPop: dismissible,
          child: GestureWrapper(
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
