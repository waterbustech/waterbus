part of 'themes_bloc.dart';

abstract class ThemesEvent {}

class ThemeChange extends ThemesEvent {
  final ThemeMode mode;
  ThemeChange({required this.mode});
}

class ThemeChangeColorSeed extends ThemesEvent {
  final ColorSeed colorSeed;
  ThemeChangeColorSeed({required this.colorSeed});
}
