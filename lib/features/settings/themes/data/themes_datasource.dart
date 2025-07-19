import 'package:flutter/material.dart';

import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus/core/constants/storage_keys.dart';

abstract class ThemesDatasource {
  void setTheme({required String themeMode});

  ThemeMode getTheme();
}

@LazySingleton(as: ThemesDatasource)
class ThemesDatasourceImpl extends ThemesDatasource {
  final Box hiveBox = Hive.box(StorageKeys.boxAppSettings);

  @override
  void setTheme({required String themeMode}) {
    hiveBox.put(StorageKeys.theme, themeMode);
  }

  @override
  ThemeMode getTheme() {
    final String? themeLabel = hiveBox.get(StorageKeys.theme);

    if (themeLabel == null) return ThemeMode.system;

    return ThemeMode.values.firstWhere(
      (theme) => theme.name == themeLabel,
      orElse: () => ThemeMode.system,
    );
  }
}
