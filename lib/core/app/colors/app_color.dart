// Flutter imports:
import 'package:flutter/material.dart';

const Color colorBlack = Color(0xFF121212);
const Color colorPrimaryBlack = Color(0xFF14171A);
const Color colorDarkGrey = Color(0xFF657786);
const Color colorPrimary = Color(0xFF1DA1F2);
const Color colorTitle = Color(0xFF2C3D50);

const Color colorHigh = Colors.redAccent;
final Color colorMedium = Colors.amber.shade700;
const Color colorLow = colorPrimary;
const Color colorCompleted = Colors.green;
const Color colorFailed = colorDarkGrey;
const Color colorActive = Color(0xFF00D72F);
const Color colorGreenLight = Color(0xFF009E60);
const Color colorAttendance = Color(0xFF0CCF4C);

const Color colorBlueGrey = Color(0xFF455A64);
const Color colorBlueGreyDark = Color(0xFF1E2224);
const Color colorBlueGreyIos = Color(0xFF1C1F2E);
const Color colorGray2 = Color(0xFFACACB9);
const Color colorGray3 = Color(0xFF6B6B74);
const Color colorGray4 = Color(0xFF9595A4);
const Color colorCyan = Color(0xFF00B3FF);
const Color colorBlue = Color(0xFF0080FF);
const Color colorPurple = Color(0xFFC848FF);
const Color colorRedCustom = Color(0xFFFF1D61);
const Color colorRedOrange = Color(0xFFEF4704);

const Color colorGreyWhite = Color(0x4dE3E3E3);
const Color colorGreyWhite2 = Color(0xFFE3E3E3);

const Color colorBlack1 = Color(0xFF0d0d0d);

final Color colorRedTitle = Colors.red.shade800;
final Color bgNotifyFail = Colors.red.shade100;

Color mC = Colors.grey.shade100;
Color mCL = Colors.white;
Color mCM = Colors.grey.shade200;
Color mCU = Colors.grey.shade300;
Color mCH = Colors.grey.shade400;
Color mGB = Colors.grey.shade500;
Color mGD = Colors.grey.shade900;
Color mCD = Colors.black.withOpacity(0.075);
Color mCC = Colors.green.withOpacity(0.65);
Color fCD = Colors.grey.shade700;
Color fCL = Colors.grey;

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
      background: mCL,
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
      divider: Colors.white12,
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
