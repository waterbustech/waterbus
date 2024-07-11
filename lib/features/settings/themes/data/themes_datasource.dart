import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus/core/constants/storage_keys.dart';
import 'package:waterbus/core/types/enums/color_seed.dart';

abstract class ThemesDatasource {
  void setTheme({required String themeMode});
  void setColorSeed({required ColorSeed colorSeed});

  ThemeMode getTheme();
  ColorSeed getColorSeed();
}

@LazySingleton(as: ThemesDatasource)
class ThemesDatasourceImpl extends ThemesDatasource {
  final Box hiveBox = Hive.box(StorageKeys.boxAppSettings);

  @override
  void setTheme({required String themeMode}) {
    hiveBox.put(StorageKeys.theme, themeMode);
  }

  @override
  void setColorSeed({required ColorSeed colorSeed}) {
    hiveBox.put(StorageKeys.colorSeed, colorSeed.label);
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

  @override
  ColorSeed getColorSeed() {
    final String? colorSeedLabel = hiveBox.get(StorageKeys.colorSeed);

    if (colorSeedLabel == null) return ColorSeed.baseColor;

    return ColorSeed.values.firstWhere(
      (color) => color.label == colorSeedLabel,
      orElse: () => ColorSeed.baseColor,
    );
  }
}
