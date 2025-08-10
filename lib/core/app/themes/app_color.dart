import 'package:flutter/material.dart';

import 'package:waterbus/core/constants/color_constants.dart';

class AppColor {
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color background;
  final Color focusColor;
  final Color unFocusColor;
  final Color activeColor;
  final Color accent;
  final Color disabled;
  final Color error;
  final Color divider;
  final Color dividerBackgroundColor;
  final Color header;
  final Color button;
  final Color contentText1;
  final Color contentText2;
  final Color subText1;
  final Color subText2;
  final Color card;

  const AppColor({
    required this.activeColor,
    required this.header,
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.background,
    required this.focusColor,
    required this.unFocusColor,
    required this.accent,
    required this.disabled,
    required this.error,
    required this.divider,
    required this.dividerBackgroundColor,
    required this.button,
    required this.contentText1,
    required this.contentText2,
    required this.subText1,
    required this.subText2,
    required this.card,
  });

  factory AppColor.light() {
    return AppColor(
      activeColor: colorPrimary,
      header: colorBlack,
      primary: colorPrimary,
      primaryLight: mCL,
      primaryDark: colorBlack,
      background: mC,
      focusColor: colorPrimary,
      unFocusColor: Colors.grey.shade700,
      accent: const Color(0xFF17c063),
      disabled: Colors.black12,
      error: const Color(0xFFB31D1D),
      divider: Colors.black26,
      dividerBackgroundColor: colorBlack,
      button: const Color(0xFF657786),
      contentText1: colorBlack,
      contentText2: colorBlack,
      subText1: colorBlack,
      subText2: mGB,
      card: mCM,
    );
  }

  factory AppColor.dark() {
    return AppColor(
      activeColor: colorPrimary,
      header: colorBlack,
      primary: colorPrimary,
      primaryLight: mCL,
      primaryDark: colorDarkGrey,
      background: colorPrimaryBlack,
      focusColor: colorPrimary,
      unFocusColor: mCH,
      accent: const Color(0xFF17c063),
      disabled: mCL,
      error: const Color(0xFFe66565),
      divider: colorGreyWhite,
      dividerBackgroundColor: colorBlack,
      button: const Color(0xFF657786),
      contentText1: mC,
      contentText2: mCM,
      subText1: mCM,
      subText2: mGB,
      card: colorBlueGreyDark,
    );
  }
}
