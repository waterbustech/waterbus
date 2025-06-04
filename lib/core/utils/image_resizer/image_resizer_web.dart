import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<void> initImageCompress() async {}

Future<Uint8List> reduceImageSize(String pathImage, {int quality = 80}) async {
  final buffer = await FlutterImageCompress.compressWithFile(
    pathImage,
    quality: quality,
    numberOfRetries: 2,
    format: CompressFormat.webp,
  );

  return buffer ?? File(pathImage).readAsBytesSync();
}
