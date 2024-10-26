// ignore_for_file: depend_on_referenced_packages

import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

@singleton
class FileSaverHelper {
  Future<bool> saveFile(final String url) async {
    if (Platform.isAndroid || Platform.isIOS) {
      return _saveFileForPhone(url);
    }

    return _saveFileForDesktop(url);
  }

  Future<bool> _saveFileForDesktop(final String url) async {
    final String fileName = path.basenameWithoutExtension(url);
    final String fileExtension = path.extension(url).replaceFirst('.', '');

    final String? savedPath = await FileSaver.instance.saveAs(
      name: fileName,
      link: LinkDetails(link: url),
      ext: fileExtension,
      mimeType: _getMimeType(fileExtension),
    );

    return savedPath != null;
  }

  Future<bool> _saveFileForPhone(final String url) async {
    final appDocDir = await getTemporaryDirectory();
    final String savePath = "${appDocDir.path}/temp.mp4";
    final String fileUrl = url;
    await Dio().download(fileUrl, savePath);
    await ImageGallerySaver.saveFile(savePath);

    return true;
  }

  MimeType _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'xlsx':
      case 'xls':
        return MimeType.microsoftExcel;
      case 'pdf':
        return MimeType.pdf;
      case 'jpg':
      case 'jpeg':
        return MimeType.jpeg;
      case 'png':
        return MimeType.png;
      case 'txt':
        return MimeType.text;
      default:
        return MimeType.other;
    }
  }
}
