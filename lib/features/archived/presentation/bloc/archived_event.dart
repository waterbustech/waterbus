part of 'archived_bloc.dart';

abstract class ArchivedEvent {}

class ArchivedStarted extends ArchivedEvent {}

class ArchivedGetMore extends ArchivedEvent {}

class ArchivedInsert extends ArchivedEvent {
  final Meeting meeting;

  ArchivedInsert({required this.meeting});
}

class ArchivedRefresh extends ArchivedEvent {
  final Function handleFinish;

  ArchivedRefresh({required this.handleFinish});
}
