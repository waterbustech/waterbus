import 'dart:typed_data';

import 'package:simple_native_image_compress/simple_native_image_compress.dart';

Future<void> initImageCompress() async {
  await NativeImageCompress.init();
}

Future<Uint8List> reduceImageSize(String pathImage, {int quality = 80}) async {
  final bytes = await ImageCompress.contain(
    filePath: pathImage,
    compressFormat: CompressFormat.webP,
    quality: quality,
  );

  return bytes;
}
