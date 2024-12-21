part of 'home_bloc.dart';

abstract class HomeEvent {}

class HomeChanged extends HomeEvent {
  final int tabIndex;
  HomeChanged({required this.tabIndex});
}

class HomeNavigateToRoot extends HomeEvent {}
