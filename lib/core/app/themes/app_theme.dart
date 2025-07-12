import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/types/enums/color_seed.dart';
import 'package:waterbus/core/utils/platform_utils.dart';
import 'package:waterbus/gen/fonts.gen.dart';

class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class AppTheme {
  AppTheme({
    required this.data,
  });

  factory AppTheme.light({
    ColorSeed colorSeed = ColorSeed.blue,
    List<ThemeExtension> extensions = const [],
  }) {
    final appColors = AppColor.light();
    final themeData = ThemeData(
      colorSchemeSeed: colorSeed.color,
      cardColor: Colors.black.withValues(alpha: .04),
      textTheme: TextTheme(
        labelMedium: TextStyle(color: fCD),
      ),
      pageTransitionsTheme: kIsWeb
          ? PageTransitionsTheme(
              builders: {
                for (final platform in TargetPlatform.values)
                  platform: const NoTransitionsBuilder(),
              },
            )
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
            modalBarrierColor: Colors.blueGrey.withValues(alpha: .2),
          ),
      appBarTheme: AppBarTheme(
        scrolledUnderElevation: 0,
        surfaceTintColor: appColors.background,
        backgroundColor: appColors.background,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light ==
                  (PlatformUtils.isAndroid ? Brightness.dark : Brightness.light)
              ? Brightness.light
              : Brightness.dark,
          statusBarIconBrightness: Brightness.light ==
                  (PlatformUtils.isAndroid ? Brightness.dark : Brightness.light)
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
      fontFamily: FontFamily.helvetica,
      extensions: extensions,
    );
    return AppTheme(
      data: themeData,
    );
  }

  factory AppTheme.dark({
    ColorSeed colorSeed = ColorSeed.blue,
    List<ThemeExtension> extensions = const [],
  }) {
    final appColors = AppColor.dark();
    final themeData = ThemeData(
      colorSchemeSeed: colorSeed.color,
      cardColor: mGD,
      textTheme: TextTheme(
        labelMedium: TextStyle(color: mCU),
      ),
      pageTransitionsTheme: kIsWeb
          ? PageTransitionsTheme(
              builders: {
                for (final platform in TargetPlatform.values)
                  platform: const NoTransitionsBuilder(),
              },
            )
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
                  (PlatformUtils.isAndroid ? Brightness.dark : Brightness.light)
              ? Brightness.light
              : Brightness.dark,
          statusBarIconBrightness: Brightness.dark ==
                  (PlatformUtils.isAndroid ? Brightness.dark : Brightness.light)
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
      fontFamily: FontFamily.helvetica,
      extensions: extensions,
    );
    return AppTheme(
      data: themeData,
    );
  }

  final ThemeData data;
}
