import 'package:waterbus/features/settings/domain/entities/language.dart';

abstract class LanguageRepository {
  void saveLocale(String langCode);
  Language getLocale();
  bool getIsLanguage(String locale);
}
