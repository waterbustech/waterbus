part of 'user_search_bloc.dart';

sealed class UserSearchState extends Equatable {
  const UserSearchState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserSearchState {}

class ActiveUserSearchState extends UserSearchState {
  final List<User> userSearchs;

  const ActiveUserSearchState({
    required this.userSearchs,
  });

  @override
  List<Object> get props => [userSearchs];
}

class UserSearchingState extends ActiveUserSearchState {
  const UserSearchingState({required super.userSearchs});
}

class UserSearchGetMore extends ActiveUserSearchState {
  const UserSearchGetMore({required super.userSearchs});
}

class UserSearchGetDone extends ActiveUserSearchState {
  const UserSearchGetDone({required super.userSearchs});
}
