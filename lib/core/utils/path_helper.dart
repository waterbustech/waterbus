// ignore_for_file: depend_on_referenced_packages

// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:path_provider/path_provider.dart';

class PathHelper {
  static Future<void> deleteCacheImageDir(String path) async {
    final cacheDir = Directory(path);
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  static Future<void> createDirStreamOS() async {
    final String tempWaterbusDir = await tempDirStreamOS;
    final String localStoreWaterbusDir = await localStoreDirStreamOS;
    final Directory myDir = Directory(tempWaterbusDir);
    final Directory localDir = Directory(localStoreWaterbusDir);
    if (!myDir.existsSync()) {
      await myDir.create();
    }

    if (!localDir.existsSync()) {
      await localDir.create();
    }
  }

  static Future<String> get tempDirStreamOS async =>
      '${(await getTemporaryDirectory()).path}/streamOS';

  static Future<String> get localStoreDirStreamOS async =>
      '${(await getTemporaryDirectory()).path}/hive';

  static Future<Directory> get appDir async =>
      await getApplicationDocumentsDirectory();

  static Future<Directory?> get downloadsDir async {
    Directory downloadsDirectory;
    try {
      if (Platform.isIOS) {
        downloadsDirectory = await getLibraryDirectory();
      } else {
        downloadsDirectory = await getApplicationSupportDirectory();
      }

      return downloadsDirectory;
    } on PlatformException {
      return null;
    }
  }

  static Future<int> getTempSize() async {
    final String tempWaterbusDir = await tempDirStreamOS;
    final Directory myDir = Directory(tempWaterbusDir);

    if (!myDir.existsSync()) return 0;

    return myDir.listSync().isEmpty ? 0 : ((myDir.statSync().size - 64) * 1024);
  }

  static Future<void> clearTempDir() async {
    final String tempWaterbusDir = await tempDirStreamOS;
    final Directory myDir = Directory(tempWaterbusDir);

    if (!myDir.existsSync()) return;

    myDir.deleteSync(recursive: true);
    myDir.create();
  }
}
