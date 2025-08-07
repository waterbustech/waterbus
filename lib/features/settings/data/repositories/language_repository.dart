import 'package:flutter/material.dart';

import 'package:injectable/injectable.dart';

import 'package:waterbus/features/settings/data/datasource/language_local_data_source.dart';
import 'package:waterbus/features/settings/domain/entities/language.dart';
import 'package:waterbus/features/settings/domain/repositories/language_repository.dart';

@LazySingleton(as: LanguageRepository)
class LanguageRepositoryImpl extends LanguageRepository {
  final LanguageLocalDataSource languageLocalDataSource =
      LanguageLocalDataSourceImpl();

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

  @override
  void saveLocale(String langCode) {
    languageLocalDataSource.setLocale(langCode: langCode);
  }

  @override
  Language getLocale() {
    final String? langCode = languageLocalDataSource.getLocale();
    switch (langCode) {
      case "en":
        return Language.english;
      case 'vi':
        return Language.vietnam;
      default:
        return Language.english;
    }
  }

  @override
  bool getIsLanguage(String locale) {
    return languageLocalDataSource.getLocale() == locale;
  }
}
