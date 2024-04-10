import 'dart:ui';

import 'package:waterbus/core/app/datasource/settings_manager_datasource.dart';
import 'package:waterbus/core/app/lang/models/language_model.dart';

class LanguageService {
  static List<Locale> supportLanguages = [
    const Locale("en"),
    const Locale("vi"),
    const Locale("da"),
    const Locale("de"),
    const Locale("el"),
    const Locale("fr"),
    const Locale("id"),
    const Locale("ja"),
    const Locale("ko"),
    const Locale("nl"),
    const Locale("zh"),
    const Locale("ru"),
  ];
  void saveLocale(String langCode) {
    SettingsManagerDatasourceImpl().setLocale(langCode: langCode);
  }

  Language getLocale() {
    final String? langCode = SettingsManagerDatasourceImpl().getLocale();
    switch (langCode) {
      case "en":
        return Language.english;
      case 'vi':
        return Language.vietnam;
      default:
        return Language.english; // default
    }
  }
}
