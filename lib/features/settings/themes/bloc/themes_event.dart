part of 'themes_bloc.dart';

abstract class ThemesEvent {}

class ThemeChanged extends ThemesEvent {
  final ThemeMode mode;
  ThemeChanged({required this.mode});
}

class ThemeChangeColorSeeded extends ThemesEvent {
  final ColorSeed colorSeed;
  ThemeChangeColorSeeded({required this.colorSeed});
}
