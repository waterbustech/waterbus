part of 'themes_bloc.dart';

abstract class ThemesEvent {}

class OnThemeChangedEvent extends ThemesEvent {
  final ThemeMode mode;
  OnThemeChangedEvent({required this.mode});
}

class OnColorSeedChangedEvent extends ThemesEvent {
  final ColorSeed colorSeed;
  OnColorSeedChangedEvent({required this.colorSeed});
}
