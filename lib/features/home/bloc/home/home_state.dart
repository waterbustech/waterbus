part of 'home_bloc.dart';

abstract class HomeState {
  List get props => [];
}

class HomeInitial extends HomeState {
  final int index;
  HomeInitial({required this.index});

  @override
  List get props => [index];
}
