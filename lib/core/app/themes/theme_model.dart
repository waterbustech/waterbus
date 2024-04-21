// Dart imports:
import 'package:flutter/material.dart';

enum ThemeList {
  light(
    ThemeMode.light,
    'Light',
  ),
  dark(
    ThemeMode.dark,
    'Dark',
  ),
  system(
    ThemeMode.system,
    'System',
  );

  const ThemeList(
    this.theme,
    this.text,
  );

  final ThemeMode theme;
  final String text;
}
