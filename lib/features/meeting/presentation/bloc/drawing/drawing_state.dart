part of 'drawing_bloc.dart';

abstract class DrawingState extends Equatable {
  final List<DrawingModel?> localProps;
  final List<DrawingModel?> remoteProps;

  const DrawingState({this.localProps = const [], this.remoteProps = const []});
  @override
  List<DrawingModel?> get props => [...localProps, ...remoteProps];
}

final class DrawingInitialState extends DrawingState {}

final class MyDrawingState extends DrawingState {
  final List<DrawingModel?> drawingModel;

  const MyDrawingState(this.drawingModel);

  @override
  List<DrawingModel?> get localProps => [...drawingModel];
}

final class AnotherDrawingState extends DrawingState {
  final List<DrawingModel?> drawingModel;

  const AnotherDrawingState(this.drawingModel);
  @override
  List<DrawingModel?> get remoteProps => [...drawingModel];
}
