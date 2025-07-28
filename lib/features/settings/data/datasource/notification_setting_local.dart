import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus/core/constants/storage_keys.dart';
import 'package:waterbus/features/settings/presentation/xmodels/notification_settings.dart';

abstract class NotificationSettingLocal {
  NotificationSettings get getNotificationSettings;
  void updateNotificationSettings(NotificationSettings settings);
}

@LazySingleton(as: NotificationSettingLocal)
class NotificationSettingLocalImpl extends NotificationSettingLocal {
  final Box _hiveBox = Hive.box(StorageKeys.boxAppSettings);

  @override
  NotificationSettings get getNotificationSettings {
    final rawList = _hiveBox.get(StorageKeys.notificationSettings);

    return NotificationSettings.fromJson(rawList);
  }

  @override
  void updateNotificationSettings(NotificationSettings settings) {
    _hiveBox.put(StorageKeys.notificationSettings, settings.toJson());
  }
}
