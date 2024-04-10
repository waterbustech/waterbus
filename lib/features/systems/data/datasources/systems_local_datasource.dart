// Dart imports:
import 'dart:io';

// Package imports:
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/constants/storage_keys.dart';

abstract class SystemLocalDataSource {
  int get getThemeMode;
  void saveThemeMode(int index);
  String get getLocale;
  void saveLocale(String locale);
}

@LazySingleton(as: SystemLocalDataSource)
class SystemLocalDataSourceImpl implements SystemLocalDataSource {
  static String? _localeStr;

  final Box hiveBox = Hive.box(StorageKeys.boxSystem);

  @override
  int get getThemeMode {
    return hiveBox.get(StorageKeys.themeMode) ?? 0;
  }

  @override
  void saveThemeMode(int index) {
    hiveBox.put(StorageKeys.themeMode, index);
  }

  @override
  String get getLocale {
    if (_localeStr != null) return _localeStr!;

    final String locale =
        hiveBox.get(StorageKeys.locale) ?? Platform.localeName.split('_')[0];

    _localeStr = locale;

    return locale;
  }

  @override
  void saveLocale(String locale) {
    _localeStr = locale;
    hiveBox.put(StorageKeys.locale, locale);
  }
}
