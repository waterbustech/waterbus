// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/types/slide.dart';

Future showDialogWaterbus({
  Slide slideFrom = Slide.bot,
  required Widget child,
  int duration = 300,
  double paddingTop = 0.0,
  double paddingBottom = 0.0,
  Color? backgroundColor,
  double paddingHorizontal = 15.0,
  double borderRadius = 25.0,
  bool dismissible = true,
  Color? barrierColor,
  int? timeForDismiss,
  double? maxHeight,
  double? maxWidth,
  bool isBottomDialog = false,
  bool onlyShowAsDialog = false,
  AlignmentGeometry? alignment,
  String routeName = Routes.dialogRoute,
}) async {
  if (!SizerUtil.isDesktop && !onlyShowAsDialog) {
    return showModalBottomSheet(
      context: AppNavigator.context!,
      builder: (context) {
        return child;
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
    barrierColor: barrierColor ?? Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: duration),
    context: AppNavigator.context!,
    pageBuilder: (context, __, ___) {
      final double width = MediaQuery.of(context).size.width;
      final double height = MediaQuery.of(context).size.height;
      return Dialog(
        alignment: alignment,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        insetPadding: EdgeInsets.only(
          left: paddingHorizontal,
          right: paddingHorizontal,
          top: paddingTop,
          bottom: paddingBottom,
        ),
        backgroundColor: backgroundColor ??
            Theme.of(AppNavigator.context!).scaffoldBackgroundColor,
        child: PopScope(
          canPop: dismissible,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: maxHeight ??
                  (isBottomDialog
                      ? (height > width ? .975 * width : .9 * height)
                      : double.infinity),
              maxWidth: maxWidth ?? (isBottomDialog ? .65 * width : 330.sp),
            ),
            child: child,
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
