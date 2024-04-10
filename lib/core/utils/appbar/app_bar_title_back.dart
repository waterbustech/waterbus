// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';

AppBar appBarTitleBack(
  BuildContext context, {
  String title = '',
  List<Widget>? actions,
  Function()? onBackPressed,
  Color? backgroundColor,
  Brightness? brightness,
  double? paddingLeft,
  Color? colorChild,
  PreferredSizeWidget? bottom,
  Widget? titleWidget,
  Widget? leading,
  double? elevation,
  bool centerTitle = true,
  bool isVisibleBackButton = true,
  double? titleSpacing,
  double? titleTextSize,
  double? toolbarHeight,
}) {
  return AppBar(
    toolbarHeight: toolbarHeight,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: (brightness ?? Theme.of(context).brightness) ==
              (Platform.isAndroid ? Brightness.dark : Brightness.light)
          ? Brightness.light
          : Brightness.dark,
      statusBarIconBrightness: (brightness ?? Theme.of(context).brightness) ==
              (Platform.isAndroid ? Brightness.dark : Brightness.light)
          ? Brightness.light
          : Brightness.dark,
    ),
    elevation: elevation ?? 0.0,
    backgroundColor: backgroundColor ?? Colors.transparent,
    automaticallyImplyLeading: false,
    centerTitle: centerTitle,
    leadingWidth: 40.sp,
    titleSpacing: titleSpacing,
    title: titleWidget ??
        Text(
          title,
          style: TextStyle(
            fontSize: titleTextSize ?? 13.5.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
    leading: !isVisibleBackButton
        ? null
        : leading ??
            GestureWrapper(
              onTap: () {
                if (onBackPressed != null) {
                  onBackPressed();
                } else {
                  AppNavigator.pop();
                }
              },
              child: Tooltip(
                message: 'Back',
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: paddingLeft ?? 3.sp),
                  child: Icon(
                    PhosphorIcons.arrow_left,
                    size: 20.sp,
                    color: colorChild,
                  ),
                ),
              ),
            ),
    actions: actions,
    bottom: bottom,
  );
}
