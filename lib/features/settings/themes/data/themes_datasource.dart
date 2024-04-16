import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus/core/constants/constants.dart';

import 'package:waterbus/core/constants/storage_keys.dart';

abstract class ThemesDatasource {
  //Themes
  void setTheme({required String appTheme});
  ThemeMode getTheme();
}

@LazySingleton(as: ThemesDatasource)
class ThemesDatasourceImpl extends ThemesDatasource {
  final Box hiveBox = Hive.box(StorageKeys.boxAppSettings);

  @override
  void setTheme({required String appTheme}) {
    hiveBox.put(
      StorageKeys.boxTheme,
      appTheme,
    );
  }

  @override
  ThemeMode getTheme() {
    final String? themeString = hiveBox.get(StorageKeys.boxTheme);
    switch (themeString) {
      case ThemeList.dark:
        return ThemeMode.dark;
      case ThemeList.light:
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }
}
