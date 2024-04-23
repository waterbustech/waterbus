// Package imports:
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/app/themes/theme_model.dart';
import 'package:waterbus/core/constants/storage_keys.dart';

abstract class ThemesDatasource {
  //Themes
  void setTheme({required String appTheme});
  ThemeList getTheme();
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
  ThemeList getTheme() {
    final String? themeString = hiveBox.get(StorageKeys.boxTheme);
    if (themeString == ThemeList.dark.text) {
      return ThemeList.dark;
    } else if (themeString == ThemeList.light.text) {
      return ThemeList.light;
    } else {
      return ThemeList.system;
    }
  }
}
