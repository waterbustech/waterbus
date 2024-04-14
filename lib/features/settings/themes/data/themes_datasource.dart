import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus/core/app/themes/app_theme.dart';
import 'package:waterbus/core/constants/constants.dart';

import 'package:waterbus/core/constants/storage_keys.dart';

abstract class ThemesDatasource {
  //Themes
  void setTheme({required String appTheme});
  String? getTheme();
  AppTheme getAppTheme();
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
  String? getTheme() {
    return hiveBox.get(StorageKeys.boxTheme);
  }

  @override
  AppTheme getAppTheme() {
    final String? theme = hiveBox.get(StorageKeys.boxTheme);
    switch (theme) {
      case ThemeList.light:
        return AppTheme.light();
      case ThemeList.dark:
        return AppTheme.dark();
      default:
        return AppTheme.dark(); // default theme
    }
  }
}
