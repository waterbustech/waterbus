part of 'drawing_bloc.dart';

abstract class DrawingState extends Equatable {
  final List<Stroke> localProps; // Marked as final
  final List<Stroke> remoteProps; // Marked as final

  const DrawingState({this.localProps = const [], this.remoteProps = const []});

  @override
  List<Stroke> get props => [...localProps, ...remoteProps];
}

final class DrawingInitialState extends DrawingState {}

// Trạng thái vẽ cục bộ
final class LocalDrawingState extends DrawingState {
  const LocalDrawingState({
    super.localProps,
    super.remoteProps,
  });

  // Phương thức thêm Stroke vào danh sách hiện có
  LocalDrawingState addStroke(Stroke stroke) {
    final updatedLocalProps = List<Stroke>.from(localProps)..add(stroke);
    return LocalDrawingState(
      localProps: updatedLocalProps,
      remoteProps: remoteProps,
    );
  }
}

final class RemoteDrawingState extends DrawingState {
  final List<Stroke> drawingModel; // Marked as final

  const RemoteDrawingState(this.drawingModel)
      : super(remoteProps: drawingModel);

  @override
  List<Stroke> get remoteProps => [...drawingModel];
}
