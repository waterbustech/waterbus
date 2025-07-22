import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/utils/platform_utils.dart';
import 'package:waterbus/gen/fonts.gen.dart';

class _DraculaColors {
  const _DraculaColors();

  static const Color background = Color(0xFF282A36);
  static const Color currentLine = Color(0xFF44475A);
  static const Color foreground = Color(0xFFF8F8F2);
  static const Color purple = Color(0xFFBD93F9);
  static const Color red = Color(0xFFFF5555);
}

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
    List<ThemeExtension> extensions = const [],
  }) {
    final appColors = AppColor.light();
    final themeData = ThemeData(
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
      fontFamily: FontFamily.geistMono,
      extensions: extensions,
    );
    return AppTheme(
      data: themeData,
    );
  }

  factory AppTheme.dark({
    List<ThemeExtension> extensions = const [],
  }) {
    final themeData = ThemeData(
      // --- General ---
      brightness: Brightness.dark,
      fontFamily: FontFamily.geistMono,
      scaffoldBackgroundColor: _DraculaColors.background,
      // Use the iconic Dracula Purple as the seed for the color scheme.
      // This will generate complementary shades for things like buttons, sliders, etc.
      colorSchemeSeed: _DraculaColors.purple,
      // Use a slightly lighter background color for cards to make them pop.
      cardColor: _DraculaColors.currentLine,
      // Use the main foreground color for text for maximum readability.
      textTheme: const TextTheme(
        labelMedium: TextStyle(color: _DraculaColors.foreground),
      ),
      dividerColor: _DraculaColors.currentLine,
      dividerTheme: const DividerThemeData(
        color: _DraculaColors.currentLine,
        space: 0,
        thickness: 0.8,
      ),

      // --- App Bar ---
      appBarTheme: const AppBarTheme(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: _DraculaColors.background,
        // Set status bar icons to light for contrast with the dark background.
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ),
        iconTheme: IconThemeData(
          color: _DraculaColors.foreground,
        ),
      ),

      // --- Components ---
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: _DraculaColors.red, // Use Dracula's red for errors.
        behavior: SnackBarBehavior.floating,
        contentTextStyle: TextStyle(color: _DraculaColors.foreground),
      ),
      bottomSheetTheme: ThemeData.dark().bottomSheetTheme.copyWith(
            backgroundColor: _DraculaColors.currentLine,
            elevation: 0,
            modalElevation: 0,
            modalBackgroundColor: _DraculaColors.background,
          ),

      // --- Page Transitions ---
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

      // --- Extensions ---
      extensions: extensions,
    );
    return AppTheme(
      data: themeData,
    );
  }

  final ThemeData data;
}
