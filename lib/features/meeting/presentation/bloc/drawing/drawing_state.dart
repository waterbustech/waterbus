part of 'drawing_bloc.dart';

abstract class DrawingState {
  List<Offset?> get props => [];
  List<Offset?> get myProps => [];
  List<Offset?> get anotherProps => [];
}

final class DrawingInitialState extends DrawingState {
  @override
  List<Offset?> get props => [...myProps, ...anotherProps];
}

final class MyDrawingState extends DrawingState {
  final DrawingModel drawingModel;

  MyDrawingState({required this.drawingModel});

  @override
  List<Offset?> get myProps => drawingModel.points;
  @override
  List<Offset?> get props => [...myProps, ...anotherProps];
}

final class AnotherDrawingState extends DrawingState {
  final List<Offset?> points;

  AnotherDrawingState({required this.points});

  @override
  List<Offset?> get anotherProps => points;
  @override
  List<Offset?> get props => [...myProps, ...anotherProps];
}
