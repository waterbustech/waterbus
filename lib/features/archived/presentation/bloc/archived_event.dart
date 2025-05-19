part of 'archived_bloc.dart';

abstract class ArchivedEvent {}

class ArchivedStarted extends ArchivedEvent {}

class ArchivedDataFetched extends ArchivedEvent {}

class ArchivedInserted extends ArchivedEvent {
  final Room room;

  ArchivedInserted({required this.room});
}

class ArchivedRefreshed extends ArchivedEvent {
  final Function handleFinish;

  ArchivedRefreshed({required this.handleFinish});
}
