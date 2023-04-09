part of 'home_bloc.dart';

abstract class HomeEvent {}

class OnChangeTabEvent extends HomeEvent {
  final int tabIndex;
  OnChangeTabEvent({required this.tabIndex});
}

class GoToRootEvent extends HomeEvent {}
