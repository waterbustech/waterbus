part of 'theme_bloc.dart';

abstract class ThemeEvent {}

class InitialTheme extends ThemeEvent {}

class OnChangeTheme extends ThemeEvent {
  final ThemeMode? themeMode;

  OnChangeTheme({
    this.themeMode,
  });
}
