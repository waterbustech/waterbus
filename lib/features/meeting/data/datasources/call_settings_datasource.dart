// Package imports:
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/constants/storage_keys.dart';
import 'package:waterbus/services/webrtc/models/call_setting.dart';

abstract class CallSettingsLocalDataSource {
  void saveSettings(CallSetting setting);
  CallSetting getSettings();
}

@LazySingleton(as: CallSettingsLocalDataSource)
class CallSettingsLocalDataSourceImpl extends CallSettingsLocalDataSource {
  final Box hiveBox = Hive.box(StorageKeys.boxCallSettings);

  @override
  void saveSettings(CallSetting setting) {
    hiveBox.put(StorageKeys.callSettings, setting.toJson());
  }

  @override
  CallSetting getSettings() {
    final String rawData = hiveBox.get(
      StorageKeys.callSettings,
      defaultValue: CallSetting().toJson(),
    );

    return CallSetting.fromJson(rawData);
  }
}
