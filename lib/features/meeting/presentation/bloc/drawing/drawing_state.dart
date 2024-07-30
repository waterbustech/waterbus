part of 'drawing_bloc.dart';

abstract class DrawingState {
   List<Offset?> get props => [];
}

final class DrawingInitialState extends DrawingState {}

final class DrawingChangedState extends DrawingState {
  final List<Offset?> points;

  DrawingChangedState({required this.points});

  @override
   List<Offset?> get props => points;
}
