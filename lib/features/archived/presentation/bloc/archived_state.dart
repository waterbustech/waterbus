part of 'archived_bloc.dart';

abstract class ArchivedState {}

class ArchivedInitial extends ArchivedState {}

class ArchivedActived extends ArchivedState {
  final List<Room> archivedConversations;

  ArchivedActived({required this.archivedConversations});
}

class ArchivedInProgress extends ArchivedActived {
  ArchivedInProgress({required super.archivedConversations});
}

class ArchivedDone extends ArchivedActived {
  ArchivedDone({required super.archivedConversations});
}
