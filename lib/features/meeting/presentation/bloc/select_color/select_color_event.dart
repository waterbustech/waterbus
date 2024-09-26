part of 'select_color_bloc.dart';

class SelectColorEvent extends Equatable {
  const SelectColorEvent();
  @override
  List<Object> get props => [];
}

class ChangeColorEvent extends SelectColorEvent {
  final Color color;
  const ChangeColorEvent({required this.color});
}
