part of 'archived_bloc.dart';

abstract class ArchivedEvent {}

class OnArchivedEvent extends ArchivedEvent {}

class GetMoreArchivedEvent extends ArchivedEvent {}

class InsertArchivedEvent extends ArchivedEvent {
  final Meeting meeting;

  InsertArchivedEvent({required this.meeting});
}

class RefreshArchivedEvent extends ArchivedEvent {
  final Function handleFinish;

  RefreshArchivedEvent({required this.handleFinish});
}
