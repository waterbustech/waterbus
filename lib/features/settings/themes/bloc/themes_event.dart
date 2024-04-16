part of 'themes_bloc.dart';

abstract class ThemesEvent {}

class OnChangeTheme extends ThemesEvent {
  final ThemeMode appTheme;
  OnChangeTheme({required this.appTheme});
}
