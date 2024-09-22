import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:universal_io/io.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/types/enums/color_seed.dart';
import 'package:waterbus/gen/fonts.gen.dart';

class AppTheme {
  AppTheme({
    required this.data,
  });

  factory AppTheme.light({ColorSeed colorSeed = ColorSeed.baseColor}) {
    final appColors = AppColor.light();
    final themeData = ThemeData(
      colorSchemeSeed: colorSeed.color,
      pageTransitionsTheme: kIsWeb
          ? null
          : const PageTransitionsTheme(
              builders: {
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              },
            ),
      brightness: Brightness.light,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: appColors.error,
        behavior: SnackBarBehavior.floating,
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
      dividerColor: appColors.divider,
      dividerTheme: DividerThemeData(
        color: appColors.divider,
        space: 0,
        thickness: .4,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: appColors.background,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      fontFamily: FontFamily.helvetica,
    );
    return AppTheme(
      data: themeData,
    );
  }

  factory AppTheme.dark({ColorSeed colorSeed = ColorSeed.baseColor}) {
    final appColors = AppColor.dark();
    final themeData = ThemeData(
      colorSchemeSeed: colorSeed.color,
      pageTransitionsTheme: kIsWeb
          ? null
          : const PageTransitionsTheme(
              builders: {
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              },
            ),
      brightness: Brightness.dark,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: appColors.error,
        behavior: SnackBarBehavior.floating,
      ),
      bottomSheetTheme: ThemeData.dark().bottomSheetTheme.copyWith(
            elevation: 0,
            modalElevation: 0,
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
      dividerColor: appColors.divider,
      dividerTheme: DividerThemeData(
        color: appColors.divider,
        space: 0,
        thickness: .4,
      ),
      dialogTheme: const DialogTheme(
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      fontFamily: FontFamily.helvetica,
    );
    return AppTheme(
      data: themeData,
    );
  }

  final ThemeData data;
}
