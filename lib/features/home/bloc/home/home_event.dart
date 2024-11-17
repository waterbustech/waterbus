part of 'home_bloc.dart';

abstract class HomeEvent {}

class HomeChange extends HomeEvent {
  final int tabIndex;
  HomeChange({required this.tabIndex});
}

class HomeGoToRoot extends HomeEvent {}
