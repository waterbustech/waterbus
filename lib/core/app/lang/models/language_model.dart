// Dart imports:
import 'dart:ui';

import 'package:waterbus/core/app/lang/data/data_languages.dart';

enum Language {
  vietnam(
    Locale('vi', 'VN'),
    Strings.vietnamese,
    'vi',
  ),
  english(
    Locale('en', 'US'),
    Strings.english,
    'en',
  );

  const Language(
    this.locale,
    this.text,
    this.langCode,
  );

  final Locale locale;
  final String text;
  final String langCode;
}
