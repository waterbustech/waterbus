part of 'archived_bloc.dart';

abstract class ArchivedEvent {}

class OnArchivedEvent extends ArchivedEvent {}

class GetMoreArchivedEvent extends ArchivedEvent {}

class InsertArchivedEvent extends ArchivedEvent {}

class RefreshArchivedEvent extends ArchivedEvent {}
