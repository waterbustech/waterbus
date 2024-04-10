
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus/core/constants/storage_keys.dart';

abstract class SettingsManagerDatasource {
  //Themes
  void setTheme({required String appTheme});
  String? getTheme();

  //Language
  void setLocale({required String langCode});
  String? getLocale();
}

@LazySingleton(as: SettingsManagerDatasource)
class SettingsManagerDatasourceImpl extends SettingsManagerDatasource {
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
  void setLocale({required String langCode}) {
    hiveBox.put(
      StorageKeys.boxLanguage,
      langCode,
    );
  }

  @override
  String? getLocale() {
    return hiveBox.get(StorageKeys.boxLanguage);
  }
}
