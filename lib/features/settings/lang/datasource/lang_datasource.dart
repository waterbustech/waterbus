import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus/core/constants/storage_keys.dart';

abstract class LanguagesDatasource {
  //Language
  void setLocale({required String langCode});
  String? getLocale();
}

@LazySingleton(as: LanguagesDatasource)
class LanguagesDatasourceImpl extends LanguagesDatasource {
  final Box hiveBox = Hive.box(StorageKeys.boxAppSettings);

  @override
  void setLocale({required String langCode}) {
    hiveBox.put(
      StorageKeys.boxLanguage,
      langCode,
    );
  }

  @override
  String? getLocale() {
    return hiveBox.get(StorageKeys.boxLanguage);
  }
}
