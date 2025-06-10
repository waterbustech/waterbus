import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/constants/storage_keys.dart';

abstract class MediaConfigLocalDataSource {
  void saveSettings(MediaConfig setting);
  MediaConfig getSettings();
}

@LazySingleton(as: MediaConfigLocalDataSource)
class MediaConfigLocalDataSourceImpl extends MediaConfigLocalDataSource {
  final Box hiveBox = Hive.box(StorageKeys.boxMediaConfig);

  @override
  void saveSettings(MediaConfig setting) {
    hiveBox.put(StorageKeys.mediaConfig, jsonEncode(setting.toJson()));
  }

  @override
  MediaConfig getSettings() {
    final String rawData = hiveBox.get(
      StorageKeys.mediaConfig,
      defaultValue: jsonEncode(MediaConfig().toJson()),
    );

    return MediaConfig.fromJson(jsonDecode(rawData));
  }
}
