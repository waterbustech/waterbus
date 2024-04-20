import 'dart:ui';

enum Language {
  english(
    Locale('en', 'US'),
    'English',
    'en',
  ),
  vietnam(
    Locale('vi', 'VN'),
    'Việt Nam',
    'vi',
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
