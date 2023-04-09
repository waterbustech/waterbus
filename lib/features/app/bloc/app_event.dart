part of 'app_bloc.dart';

abstract class AppEvent {}

class OnBackgroundEvent extends AppEvent {}

class OnResumeEvent extends AppEvent {}
