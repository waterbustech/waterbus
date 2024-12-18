part of 'user_search_bloc.dart';

sealed class UserSearchsEvent extends Equatable {
  const UserSearchsEvent();

  @override
  List<Object> get props => [];
}

class UserSearchStarted extends UserSearchsEvent {
  final String keyword;

  const UserSearchStarted({required this.keyword});
}

class UserSearchFetched extends UserSearchsEvent {}

class UserSearchRefreshed extends UserSearchsEvent {
  final Function? handleFinish;

  const UserSearchRefreshed({this.handleFinish});
}

class UserSearchClean extends UserSearchsEvent {}
