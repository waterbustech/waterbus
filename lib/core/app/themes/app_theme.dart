import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';

class AppColor {
  final Color background;
  final Color error;
  final Color contentText1;
  final Color divider;

  AppColor({
    required this.background,
    required this.error,
    required this.contentText1,
    required this.divider,
  });

  factory AppColor.light() {
    return AppColor(
      background: _SolarizedLightColors.base3,
      error: _SolarizedLightColors.red,
      contentText1: _SolarizedLightColors.base00,
      divider: _SolarizedLightColors.base2,
    );
  }
}

class PlatformUtils {
  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
}

// --- Dracula Theme Colors ---
class _DraculaColors {
  const _DraculaColors();

  static const Color background = Color(0xFF282A36);
  static const Color currentLine = Color(0xFF44475A);
  static const Color foreground = Color(0xFFF8F8F2);
  static const Color purple = Color(0xFFBD93F9);
  static const Color red = Color(0xFFFF5555);
}

// --- Solarized Light Theme Colors ---
class _SolarizedLightColors {
  const _SolarizedLightColors();

  static const Color base3 = Color(0xFFFDF6E3);
  static const Color base2 = Color(0xFFEEE8D5);
  static const Color base00 = Color(0xFF657B83);
  static const Color base01 = Color(0xFF586E75);
  static const Color red = Color(0xFFDC322F);
  static const Color blue = Color(0xFF268BD2);
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
    final themeData = ThemeData(
      brightness: Brightness.light,
      fontFamily: GoogleFonts.firaCode().fontFamily,
      scaffoldBackgroundColor: _SolarizedLightColors.base3,
      // Use a complementary blue as the seed for the color scheme.
      colorSchemeSeed: _SolarizedLightColors.blue,
      // Use a slightly darker off-white for cards to distinguish them.
      cardColor: _SolarizedLightColors.base2,
      // Use the main text color for readability.
      textTheme: const TextTheme(
        labelMedium: TextStyle(color: _SolarizedLightColors.base00),
        bodyLarge: TextStyle(color: _SolarizedLightColors.base00),
        bodyMedium: TextStyle(color: _SolarizedLightColors.base01),
      ),
      dividerColor: Colors.grey.shade400,
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade400,
        space: 0,
        thickness: 1,
      ),

      // --- App Bar ---
      appBarTheme: AppBarTheme(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: _SolarizedLightColors.base3,
        // Set status bar icons to dark for contrast with the light background.
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
        iconTheme: IconThemeData(
          color: _SolarizedLightColors.base01,
        ),
        titleTextStyle: TextStyle(
          color: _SolarizedLightColors.base00,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          fontFamily: GoogleFonts.firaCode().fontFamily,
        ),
      ),

      // --- Components ---
      snackBarTheme: const SnackBarThemeData(
        backgroundColor:
            _SolarizedLightColors.red, // Use Solarized red for errors.
        behavior: SnackBarBehavior.floating,
        contentTextStyle: TextStyle(color: _SolarizedLightColors.base3),
      ),
      bottomSheetTheme: ThemeData.light().bottomSheetTheme.copyWith(
            backgroundColor: _SolarizedLightColors.base2,
            elevation: 0,
            modalElevation: 0,
            modalBackgroundColor: _SolarizedLightColors.base3,
            modalBarrierColor:
                _SolarizedLightColors.base01.withValues(alpha: .2),
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

  factory AppTheme.dark({
    List<ThemeExtension> extensions = const [],
  }) {
    final themeData = ThemeData(
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.spaceMono().fontFamily,
      scaffoldBackgroundColor: _DraculaColors.background,
      // Use the iconic Dracula Purple as the seed for the color scheme.
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
