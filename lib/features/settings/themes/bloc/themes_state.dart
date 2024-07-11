part of 'themes_bloc.dart';

abstract class ThemesState {
  List get props => [];
}

class ThemesStateInitial extends ThemesState {
  final ThemeMode mode;
  final ColorSeed colorSeed;
  ThemesStateInitial({required this.mode, required this.colorSeed});

  @override
  List get props => [mode, colorSeed];
}
