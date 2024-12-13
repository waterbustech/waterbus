part of 'archived_bloc.dart';

abstract class ArchivedEvent {}

class ArchivedStarted extends ArchivedEvent {}

class ArchivedDataFetched extends ArchivedEvent {}

class ArchivedInserted extends ArchivedEvent {
  final Meeting meeting;

  ArchivedInserted({required this.meeting});
}

class ArchivedRefreshed extends ArchivedEvent {
  final Function handleFinish;

  ArchivedRefreshed({required this.handleFinish});
}
