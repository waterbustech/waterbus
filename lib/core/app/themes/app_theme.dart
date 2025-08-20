import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:waterbus/core/app/themes/preset.dart';

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

  factory AppColor.fromPreset(Preset preset) {
    switch (preset) {
      case Preset.dracula:
        return AppColor(
          background: _DraculaColors.background,
          error: _DraculaColors.red,
          contentText1: _DraculaColors.foreground,
          divider: _DraculaColors.currentLine,
        );
      case Preset.tokyoNight:
        return AppColor(
          background: _TokyoNightColors.background,
          error: _TokyoNightColors.red,
          contentText1: _TokyoNightColors.foreground,
          divider: _TokyoNightColors.comment,
        );
      case Preset.atomOneDark:
        return AppColor(
          background: _AtomOneDarkColors.background,
          error: _AtomOneDarkColors.red,
          contentText1: _AtomOneDarkColors.foreground,
          divider: _AtomOneDarkColors.gutter,
        );
      case Preset.oneDarkPro:
        return AppColor(
          background: _OneDarkProColors.background,
          error: _OneDarkProColors.red,
          contentText1: _OneDarkProColors.foreground,
          divider: _OneDarkProColors.border,
        );
      case Preset.catppuccin:
        return AppColor(
          background: _CatppuccinColors.background,
          error: _CatppuccinColors.red,
          contentText1: _CatppuccinColors.text,
          divider: _CatppuccinColors.surface1,
        );
      case Preset.ayuDark:
        return AppColor(
          background: _AyuDarkColors.background,
          error: _AyuDarkColors.red,
          contentText1: _AyuDarkColors.foreground,
          divider: _AyuDarkColors.selection,
        );
    }
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

// --- Tokyo Night Theme Colors ---
class _TokyoNightColors {
  const _TokyoNightColors();

  static const Color background = Color(0xFF1a1b26);
  static const Color selection = Color(0xFF364A82);
  static const Color foreground = Color(0xFFc0caf5);
  static const Color comment = Color(0xFF565f89);
  static const Color purple = Color(0xFF9d7cd8);
  static const Color red = Color(0xFFf7768e);
}

// --- Atom One Dark Theme Colors ---
class _AtomOneDarkColors {
  const _AtomOneDarkColors();

  static const Color background = Color(0xFF282c34);
  static const Color currentLine = Color(0xFF2c323c);
  static const Color foreground = Color(0xFFabb2bf);
  static const Color red = Color(0xFFe06c75);
  static const Color blue = Color(0xFF61afef);
  static const Color gutter = Color(0xFF4b5263);
}

// --- One Dark Pro Theme Colors ---
class _OneDarkProColors {
  const _OneDarkProColors();

  static const Color background = Color(0xFF1e2127);
  static const Color currentLine = Color(0xFF2c313a);
  static const Color foreground = Color(0xFFabb2bf);
  static const Color red = Color(0xFFe55561);
  static const Color blue = Color(0xFF4aa5f0);
  static const Color border = Color(0xFF181a1f);
}

// --- Catppuccin Mocha Theme Colors ---
class _CatppuccinColors {
  const _CatppuccinColors();

  static const Color background = Color(0xFF1e1e2e);
  static const Color surface0 = Color(0xFF313244);
  static const Color surface1 = Color(0xFF45475a);
  static const Color text = Color(0xFFcdd6f4);
  static const Color red = Color(0xFFf38ba8);
  static const Color mauve = Color(0xFFcba6f7);
}

// --- Ayu Dark Theme Colors ---
class _AyuDarkColors {
  const _AyuDarkColors();

  static const Color background = Color(0xFF0f1419);
  static const Color selection = Color(0xFF253340);
  static const Color foreground = Color(0xFFbfbdb6);
  static const Color red = Color(0xFFf07178);
  static const Color blue = Color(0xFF59c2ff);
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

  factory AppTheme.fromPreset(
    Preset preset, {
    List<ThemeExtension> extensions = const [],
  }) {
    final colors = _getColorsForPreset(preset);

    final themeData = ThemeData(
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.redHatMono().fontFamily,
      scaffoldBackgroundColor: colors.background,
      colorSchemeSeed: colors.accent,
      cardColor: colors.surface,
      textTheme: TextTheme(
        labelMedium: TextStyle(color: colors.foreground),
        bodyLarge: TextStyle(color: colors.foreground),
        bodyMedium: TextStyle(color: colors.foreground.withValues(alpha: 0.8)),
      ),
      dividerColor: colors.border,
      dividerTheme: DividerThemeData(
        color: colors.border,
        space: 0,
        thickness: 0.8,
      ),

      // --- App Bar ---
      appBarTheme: AppBarTheme(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: colors.background,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ),
        iconTheme: IconThemeData(
          color: colors.foreground,
        ),
        titleTextStyle: TextStyle(
          color: colors.foreground,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          fontFamily: GoogleFonts.redHatMono().fontFamily,
        ),
      ),

      // --- Components ---
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.error,
        behavior: SnackBarBehavior.floating,
        contentTextStyle: TextStyle(color: colors.background),
      ),
      bottomSheetTheme: ThemeData.dark().bottomSheetTheme.copyWith(
            backgroundColor: colors.surface,
            elevation: 0,
            modalElevation: 0,
            modalBackgroundColor: colors.background,
            modalBarrierColor: colors.foreground.withValues(alpha: 0.2),
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

  static _PresetColors _getColorsForPreset(Preset preset) {
    switch (preset) {
      case Preset.dracula:
        return _PresetColors(
          background: _DraculaColors.background,
          surface: _DraculaColors.currentLine,
          foreground: _DraculaColors.foreground,
          accent: _DraculaColors.purple,
          error: _DraculaColors.red,
          border: _DraculaColors.currentLine,
        );
      case Preset.tokyoNight:
        return _PresetColors(
          background: _TokyoNightColors.background,
          surface: _TokyoNightColors.selection,
          foreground: _TokyoNightColors.foreground,
          accent: _TokyoNightColors.purple,
          error: _TokyoNightColors.red,
          border: _TokyoNightColors.comment,
        );
      case Preset.atomOneDark:
        return _PresetColors(
          background: _AtomOneDarkColors.background,
          surface: _AtomOneDarkColors.currentLine,
          foreground: _AtomOneDarkColors.foreground,
          accent: _AtomOneDarkColors.blue,
          error: _AtomOneDarkColors.red,
          border: _AtomOneDarkColors.gutter,
        );
      case Preset.oneDarkPro:
        return _PresetColors(
          background: _OneDarkProColors.background,
          surface: _OneDarkProColors.currentLine,
          foreground: _OneDarkProColors.foreground,
          accent: _OneDarkProColors.blue,
          error: _OneDarkProColors.red,
          border: _OneDarkProColors.border,
        );
      case Preset.catppuccin:
        return _PresetColors(
          background: _CatppuccinColors.background,
          surface: _CatppuccinColors.surface0,
          foreground: _CatppuccinColors.text,
          accent: _CatppuccinColors.mauve,
          error: _CatppuccinColors.red,
          border: _CatppuccinColors.surface1,
        );
      case Preset.ayuDark:
        return _PresetColors(
          background: _AyuDarkColors.background,
          surface: _AyuDarkColors.selection,
          foreground: _AyuDarkColors.foreground,
          accent: _AyuDarkColors.blue,
          error: _AyuDarkColors.red,
          border: _AyuDarkColors.selection,
        );
    }
  }
}

class _PresetColors {
  final Color background;
  final Color surface;
  final Color foreground;
  final Color accent;
  final Color error;
  final Color border;

  _PresetColors({
    required this.background,
    required this.surface,
    required this.foreground,
    required this.accent,
    required this.error,
    required this.border,
  });
}
