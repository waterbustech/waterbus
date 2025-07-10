import 'package:flutter/material.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/common/widgets/tooltip_message.dart';

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
  double? leadingWidth,
  bool centerTitle = true,
  bool isVisibleBackButton = true,
  double? titleSpacing,
  double? titleTextSize,
  double? toolbarHeight,
}) {
  return AppBar(
    toolbarHeight: toolbarHeight,
    systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
    elevation: elevation ?? 0.0,
    backgroundColor: backgroundColor ?? Colors.transparent,
    automaticallyImplyLeading: false,
    centerTitle: centerTitle,
    leadingWidth: leadingWidth ?? 40.sp,
    titleSpacing: titleSpacing,
    title: titleWidget ??
        Text(
          title,
          maxLines: 2,
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
                  AppRouter.pop();
                }
              },
              child: TooltipWrapper(
                message: Strings.back.i18n,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: paddingLeft ?? 3.sp),
                  child: Icon(
                    PhosphorIcons.caretLeft(PhosphorIconsStyle.light),
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
