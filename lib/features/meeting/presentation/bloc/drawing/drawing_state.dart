part of 'drawing_bloc.dart';

abstract class DrawingState {
  List get props => [];
}

final class DrawingInitialState extends DrawingState {}

final class DrawingChangedState extends DrawingState {
  final List<Offset?> points;

  DrawingChangedState({required this.points});

  @override
  List get props => [points];
}
