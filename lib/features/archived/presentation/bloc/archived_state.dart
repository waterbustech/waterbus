part of 'archived_bloc.dart';

abstract class ArchivedState {}

class ArchivedInitial extends ArchivedState {}

class ActiveArchivedState extends ArchivedState {
  final List<Meeting> archivedConversations;

  ActiveArchivedState({required this.archivedConversations});
}

class GettingArchivedState extends ActiveArchivedState {
  GettingArchivedState({required super.archivedConversations});
}

class GetDoneArchivedState extends ActiveArchivedState {
  GetDoneArchivedState({required super.archivedConversations});
}
