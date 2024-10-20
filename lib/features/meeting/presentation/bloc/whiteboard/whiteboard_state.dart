part of 'whiteboard_bloc.dart';

class WhiteBoardState extends Equatable {
  final List<DrawModel?>? paints;
  final DrawModel? currentDraw;
  const WhiteBoardState({
    this.paints,
    this.currentDraw,
  });

  @override
  List<Object?> get props => [
        paints,
        currentDraw,
      ];
}

final class WhiteBoardInitialState extends WhiteBoardState {
  WhiteBoardInitialState()
      : super(
          currentDraw: DrawModel(points: const []),
          paints: [],
        );
}

final class GetDoneWhiteBoard extends WhiteBoardState {
  const GetDoneWhiteBoard({super.currentDraw, super.paints});
}
