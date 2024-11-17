part of 'whiteboard_bloc.dart';

class WhiteBoardState extends Equatable {
  final List<DrawModel> paints;
  final DrawModel currentPaint;
  const WhiteBoardState({required this.paints, required this.currentPaint});

  @override
  List<Object?> get props => [paints, currentPaint];
}

final class WhiteBoardInitialState extends WhiteBoardState {
  WhiteBoardInitialState()
      : super(currentPaint: DrawModel(points: const []), paints: []);
}

final class WhiteBoardDone extends WhiteBoardState {
  const WhiteBoardDone({required super.currentPaint, required super.paints});
}
