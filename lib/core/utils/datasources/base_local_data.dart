import 'package:hive/hive.dart';
import 'package:waterbus_sdk/utils/path_helper.dart';

import 'package:waterbus/core/constants/storage_keys.dart';

class BaseLocalData {
  static Future<void> initialBox() async {
    final String? path = await PathHelper.localStoreDirWaterbus;
    Hive.init(path);

    await openBoxApp();
  }

  static Future<void> openBoxApp() async {
    await Future.wait([
      Hive.openBox(StorageKeys.boxAuth),
      Hive.openBox(StorageKeys.boxMeeting),
      Hive.openBox(StorageKeys.boxCallSettings),
      Hive.openBox(StorageKeys.boxAppSettings),
    ]);
  }
}
