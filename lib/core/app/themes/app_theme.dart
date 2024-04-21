// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/gen/fonts.gen.dart';

class AppTheme {
  AppTheme({
    required this.data,
  });

  factory AppTheme.light() {
    final appColors = AppColor.light();
    final themeData = ThemeData(
      useMaterial3: true,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        },
      ),
      brightness: Brightness.light,
      primaryColor: appColors.primary,
      primaryColorLight: appColors.primaryLight,
      primaryColorDark: appColors.primaryDark,
      focusColor: appColors.focusColor,
      disabledColor: appColors.unFocusColor,
      scaffoldBackgroundColor: appColors.background,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: appColors.error,
        behavior: SnackBarBehavior.floating,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: appColors.background,
        selectedItemColor: appColors.activeColor,
      ),
      bottomSheetTheme: ThemeData.dark().bottomSheetTheme.copyWith(
            elevation: 0,
            modalElevation: 0,
            modalBarrierColor: Colors.blueGrey.withOpacity(.2),
          ),
      appBarTheme: AppBarTheme(
        scrolledUnderElevation: 0,
        surfaceTintColor: appColors.background,
        backgroundColor: appColors.background,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
        ),
        iconTheme: IconThemeData(
          color: appColors.contentText1,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: appColors.header),
        displayMedium: TextStyle(color: appColors.header),
        bodyLarge: TextStyle(color: appColors.contentText1),
        bodyMedium: TextStyle(color: appColors.contentText2),
        titleMedium: TextStyle(color: appColors.subText1),
        titleSmall: TextStyle(color: appColors.subText2),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: appColors.focusColor,
      ),
      dividerColor: appColors.divider,
      dividerTheme: DividerThemeData(
        color: appColors.divider,
        space: 0,
        thickness: .4,
      ),
      fontFamily: FontFamily.helvetica,
      colorScheme: const ColorScheme.light().copyWith(
        background: appColors.dividerBackgroundColor,
        error: appColors.error,
      ),
      cardColor: appColors.card,
    );
    return AppTheme(
      data: themeData,
    );
  }

  factory AppTheme.dark() {
    final appColors = AppColor.dark();
    final themeData = ThemeData(
      useMaterial3: true,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        },
      ),
      brightness: Brightness.dark,
      primaryColor: appColors.primary,
      primaryColorLight: appColors.primaryLight,
      primaryColorDark: appColors.primaryDark,
      focusColor: appColors.focusColor,
      disabledColor: appColors.unFocusColor,
      scaffoldBackgroundColor: appColors.background,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: appColors.error,
        behavior: SnackBarBehavior.floating,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: appColors.background,
        selectedItemColor: appColors.activeColor,
      ),
      bottomSheetTheme: ThemeData.dark().bottomSheetTheme.copyWith(
            elevation: 0,
            modalElevation: 0,
            modalBarrierColor: Colors.blueGrey.withOpacity(.2),
          ),
      appBarTheme: AppBarTheme(
        scrolledUnderElevation: 0,
        surfaceTintColor: appColors.background,
        backgroundColor: appColors.background,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        iconTheme: IconThemeData(
          color: appColors.contentText1,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: appColors.header),
        displayMedium: TextStyle(color: appColors.header),
        bodyLarge: TextStyle(color: appColors.contentText1),
        bodyMedium: TextStyle(color: appColors.contentText2),
        titleMedium: TextStyle(color: appColors.subText1),
        titleSmall: TextStyle(color: appColors.subText2),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: appColors.focusColor,
      ),
      dividerColor: appColors.divider,
      dividerTheme: DividerThemeData(
        color: appColors.divider,
        space: 0,
        thickness: .4,
      ),
      fontFamily: FontFamily.helvetica,
      colorScheme: const ColorScheme.dark().copyWith(
        background: appColors.dividerBackgroundColor,
        error: appColors.error,
      ),
      cardColor: appColors.card,
    );
    return AppTheme(
      data: themeData,
    );
  }

  final ThemeData data;
}
