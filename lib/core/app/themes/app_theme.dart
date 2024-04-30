// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:universal_io/io.dart';

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
      pageTransitionsTheme: kIsWeb
          ? null
          : const PageTransitionsTheme(
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
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light ==
                  (Platform.isAndroid ? Brightness.dark : Brightness.light)
              ? Brightness.light
              : Brightness.dark,
          statusBarIconBrightness: Brightness.light ==
                  (Platform.isAndroid ? Brightness.dark : Brightness.light)
              ? Brightness.light
              : Brightness.dark,
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
      dialogTheme: DialogTheme(
        backgroundColor: appColors.background,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    );
    return AppTheme(
      data: themeData,
    );
  }

  factory AppTheme.dark() {
    final appColors = AppColor.dark();
    final themeData = ThemeData(
      useMaterial3: true,
      pageTransitionsTheme: kIsWeb
          ? null
          : const PageTransitionsTheme(
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
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark ==
                  (Platform.isAndroid ? Brightness.dark : Brightness.light)
              ? Brightness.light
              : Brightness.dark,
          statusBarIconBrightness: Brightness.dark ==
                  (Platform.isAndroid ? Brightness.dark : Brightness.light)
              ? Brightness.light
              : Brightness.dark,
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
      dialogTheme: DialogTheme(
        backgroundColor: appColors.background,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    );
    return AppTheme(
      data: themeData,
    );
  }

  final ThemeData data;
}
