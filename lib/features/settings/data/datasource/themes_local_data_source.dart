import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus/core/app/themes/preset.dart';
import 'package:waterbus/core/constants/storage_keys.dart';

abstract class ThemesLocalDataSource {
  void setTheme({required String presetName});

  Preset getTheme();
}

@LazySingleton(as: ThemesLocalDataSource)
class ThemesDatasourceImpl extends ThemesLocalDataSource {
  final Box hiveBox = Hive.box(StorageKeys.boxAppSettings);

  @override
  void setTheme({required String presetName}) {
    hiveBox.put(StorageKeys.theme, presetName);
  }

  @override
  Preset getTheme() {
    final String? presetLabel = hiveBox.get(StorageKeys.theme);

    if (presetLabel == null) return Preset.tokyoNight;

    return Preset.values.firstWhere(
      (preset) => preset.name == presetLabel,
      orElse: () => Preset.tokyoNight,
    );
  }
}
