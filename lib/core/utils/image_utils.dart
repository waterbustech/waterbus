import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:waterbus/core/utils/image_resizer/index.dart';

class ImageUtils {
  Future<void> init() async {
    await initImageCompress();
  }

  Future<Uint8List> reduceSize(String pathImage, {int quality = 80}) async {
    if (isNeedReduce(pathImage)) {
      return await reduceImageSize(pathImage, quality: quality);
    }

    return File(pathImage).readAsBytesSync();
  }

  bool isNeedReduce(String path) {
    final file = File(path);
    final int bytes = file.lengthSync();
    if (bytes <= 0) return false;
    final i = (log(bytes) / log(1024)).floor();
    final size = bytes / pow(1024, i);
    if (i < 1) {
      if (i == 1 && size > 100) {
        return false;
      }

      return true;
    }
    return true;
  }
}
