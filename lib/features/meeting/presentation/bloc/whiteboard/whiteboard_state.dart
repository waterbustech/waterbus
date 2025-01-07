part of 'whiteboard_bloc.dart';

class WhiteBoardState extends Equatable {
  final List<DrawModel> paints;
  final DrawModel currentPaint;
  final bool isOpen;
  const WhiteBoardState({
    required this.paints,
    required this.currentPaint,
    required this.isOpen,
  });

  @override
  List<Object?> get props => [paints, currentPaint, isOpen];
}

final class WhiteBoardInitialState extends WhiteBoardState {
  WhiteBoardInitialState()
      : super(
          currentPaint: DrawModel(points: const []),
          paints: [],
          isOpen: false,
        );
}

final class WhiteBoardDone extends WhiteBoardState {
  const WhiteBoardDone({
    required super.currentPaint,
    required super.paints,
    required super.isOpen,
  });
}
