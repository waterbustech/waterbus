part of 'themes_bloc.dart';

abstract class ThemesEvent {}

class ThemeChanged extends ThemesEvent {
  final Preset preset;
  ThemeChanged({required this.preset});
}
