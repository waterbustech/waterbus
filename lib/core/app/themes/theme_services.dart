import 'package:waterbus/core/app/datasource/settings_manager_datasource.dart';
import 'package:waterbus/core/app/themes/app_theme.dart';
import 'package:waterbus/core/constants/constants.dart';

class ThemeService {


  AppTheme getTheme() {
    final String? appTheme = SettingsManagerDatasourceImpl().getTheme();
    switch (appTheme) {
      case ThemeList.light:
        return AppTheme.light();
      case ThemeList.dark:
        return AppTheme.dark();
      default:
        return AppTheme.dark(); // default theme
    }
  }
}
