part of 'themes_bloc.dart';

abstract class ThemesState {
  List get props => [];
}

class ThemesStateInitial extends ThemesState {
  final AppTheme appTheme;
  ThemesStateInitial({required this.appTheme});

  @override
  List get props => [appTheme];
}
