part of 'drawing_bloc.dart';

class DrawingState extends Equatable {
  final List<DrawModel?>? drawList;
  final DrawModel? currentDraw;
  const DrawingState({
    this.drawList,
    this.currentDraw,
  });

  DrawingState copyWith({
    List<DrawModel?>? drawList,
    DrawModel? currentDraw,
  }) {
    return DrawingState(
      drawList: drawList ?? this.drawList,
      currentDraw: currentDraw ?? this.currentDraw,
    );
  }

  @override
  List<Object?> get props => [
        drawList,
        currentDraw,
      ];
}

final class DrawingInitialState extends DrawingState {
  DrawingInitialState()
      : super(
          currentDraw: DrawModel(points: const []),
          drawList: [],
        );
}
