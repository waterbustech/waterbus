part of 'drawing_bloc.dart';

abstract class DrawingState extends Equatable {
  final List<DrawModel> localProps;
  final List<DrawModel> remoteProps;

  const DrawingState({
    this.localProps = const [],
    this.remoteProps = const [],
  });

  @override
  List<DrawModel> get props => [...localProps, ...remoteProps];
}

final class DrawingInitialState extends DrawingState {}

final class UpdateDrawingState extends DrawingState {
  const UpdateDrawingState({
    super.localProps,
    super.remoteProps,
  });
}
