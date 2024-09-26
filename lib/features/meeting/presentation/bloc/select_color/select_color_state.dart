part of 'select_color_bloc.dart';

abstract class SelectColorState extends Equatable {
  final Color color;

  const SelectColorState(this.color);

  @override
  List<Object> get props => [color];
}

final class SelectColorInitial extends SelectColorState {
  SelectColorInitial() : super(availableColor[0]);
}

final class ChangeColorState extends SelectColorState {
  const ChangeColorState(super.color);
}
