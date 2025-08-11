import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus/core/constants/storage_keys.dart';
import 'package:waterbus/features/settings/domain/entities/notification_settings.dart';

abstract class NotificationSettingLocalDataSource {
  NotificationSettings get getNotificationSettings;
  void updateNotificationSettings(NotificationSettings settings);
}

@LazySingleton(as: NotificationSettingLocalDataSource)
class NotificationSettingLocalImpl extends NotificationSettingLocalDataSource {
  final Box _hiveBox = Hive.box(StorageKeys.boxAppSettings);

  @override
  NotificationSettings get getNotificationSettings {
    final String rawList =
        _hiveBox.get(StorageKeys.notificationSettings, defaultValue: "");

    if (rawList.isEmpty) return NotificationSettings();

    return NotificationSettings.fromJson(rawList);
  }

  @override
  void updateNotificationSettings(NotificationSettings settings) {
    _hiveBox.put(StorageKeys.notificationSettings, settings.toJson());
  }
}
