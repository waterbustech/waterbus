import 'package:hive/hive.dart';
import 'package:waterbus_sdk/utils/path_helper.dart';

import 'package:waterbus/core/constants/storage_keys.dart';

class BaseLocalData {
  static Future<void> initialBox() async {
    await PathHelper.createDirWaterbus();
    final String? path = await PathHelper.localStoreDirWaterbus;
    Hive.init(path);

    await openBoxApp();
  }

  static Future<void> openBoxApp() async {
    await Hive.openBox(StorageKeys.boxAuth);
    await Hive.openBox(StorageKeys.boxMeeting);
    await Hive.openBox(StorageKeys.boxCallSettings);
    await Hive.openBox(StorageKeys.boxAppSettings);
  }
}
