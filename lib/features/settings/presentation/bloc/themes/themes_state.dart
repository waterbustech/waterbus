part of 'themes_bloc.dart';

abstract class ThemesState {
  List get props => [];
}

final class ThemesStateInitial extends ThemesState {
  final Preset preset;
  ThemesStateInitial({required this.preset});

  @override
  List get props => [preset];
}
