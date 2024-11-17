part of 'archived_bloc.dart';

abstract class ArchivedState {}

class ArchivedInitial extends ArchivedState {}

class ArchivedActive extends ArchivedState {
  final List<Meeting> archivedConversations;

  ArchivedActive({required this.archivedConversations});
}

class ArchivedInProgress extends ArchivedActive {
  ArchivedInProgress({required super.archivedConversations});
}

class ArchivedDone extends ArchivedActive {
  ArchivedDone({required super.archivedConversations});
}
