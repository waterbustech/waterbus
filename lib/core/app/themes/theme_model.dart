import 'package:flutter/material.dart';

enum ThemeList {
  system(
    ThemeMode.system,
    'System',
  ),
  light(
    ThemeMode.light,
    'Light',
  ),
  dark(
    ThemeMode.dark,
    'Dark',
  );

  const ThemeList(
    this.theme,
    this.text,
  );

  final ThemeMode theme;
  final String text;
}
