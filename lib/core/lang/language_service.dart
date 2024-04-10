// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:i18n_extension/i18n_extension.dart';

// Project imports:
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/features/systems/data/datasources/systems_local_datasource.dart';

class LanguageService {
  ///Default Language
  static const locale = Locale('vi', 'VN');

  ///List Language support in Application
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

  void changeLanguage({bool isEnglish = false}) {
    if (getIsLanguage(isEnglish ? 'en' : 'vi')) return;

    SystemLocalDataSourceImpl().saveLocale(isEnglish ? "en" : "vi");
    if (isEnglish) {
      I18n.of(AppNavigator.context!).locale = const Locale("en", "US");
    } else {
      I18n.of(AppNavigator.context!).locale = const Locale("vi", "VN");
    }
  }

  void initialLanguage() {
    if (AppNavigator.context == null) return;
    final String localeStr = SystemLocalDataSourceImpl().getLocale;

    if (localeStr == "vi") {
      I18n.of(AppNavigator.context!).locale = const Locale("vi", "VN");
    } else {
      I18n.of(AppNavigator.context!).locale = const Locale("en", "US");
    }
  }

  bool getIsLanguage(String locale) {
    return SystemLocalDataSourceImpl().getLocale == locale;
  }
}
