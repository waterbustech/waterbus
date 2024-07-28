part of 'user_search_bloc.dart';

sealed class UserSearchsEvent extends Equatable {
  const UserSearchsEvent();

  @override
  List<Object> get props => [];
}

class SearchUsersEvent extends UserSearchsEvent {
  final String keyword;

  const SearchUsersEvent({required this.keyword});
}

class GetMoreUserSearchEvent extends UserSearchsEvent {}

class RefreshUserSearchEvent extends UserSearchsEvent {
  final Function? handleFinish;

  const RefreshUserSearchEvent({this.handleFinish});
}

class CleanUserSearchsEvent extends UserSearchsEvent {}
