part of 'themes_bloc.dart';

abstract class ThemesState {
  List get props => [];
  String get appThemeName;
}

class ThemesStateInitial extends ThemesState {
  final ThemeMode appTheme;
  ThemesStateInitial({required this.appTheme});

  @override
  List get props => [appTheme];

  @override
  String get appThemeName {
    switch (appTheme) {
      case ThemeMode.dark:
        return ThemeList.dark;
      case ThemeMode.light:
        return ThemeList.light;
      default:
        return ThemeList.system;
    }
  }
}
