// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:waterbus/features/systems/data/datasources/systems_local_datasource.dart';

enum ThemeOptions { light, dark }

class ThemeService {
  void switchStatusColor() {
    final SystemUiOverlayStyle systemBrightness = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: ThemeService().getThemeMode() == ThemeMode.dark
          ? Brightness.light
          : Brightness.dark,
      statusBarIconBrightness: ThemeService().getThemeMode() == ThemeMode.dark
          ? Brightness.light
          : Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(systemBrightness);
  }

  ThemeMode getThemeMode() {
    return ThemeMode.values[SystemLocalDataSourceImpl().getThemeMode];
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    SystemLocalDataSourceImpl().saveThemeMode(ThemeMode.values.indexOf(mode));
  }

  void changeThemeMode({required ThemeMode mode}) {
    saveThemeMode(mode);
    switchStatusColor();
  }
}
