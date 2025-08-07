part of 'themes_bloc.dart';

abstract class ThemesState {
  List get props => [];
}

final class ThemesStateInitial extends ThemesState {
  final ThemeMode mode;
  ThemesStateInitial({required this.mode});

  @override
  List get props => [mode];
}
