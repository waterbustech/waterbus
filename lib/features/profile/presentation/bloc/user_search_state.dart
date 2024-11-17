part of 'user_search_bloc.dart';

sealed class UserSearchState extends Equatable {
  const UserSearchState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserSearchState {}

class UserSearchActive extends UserSearchState {
  final List<User> userSearchs;

  const UserSearchActive({
    required this.userSearchs,
  });

  @override
  List<Object> get props => [userSearchs];
}

class UserSearchInprogress extends UserSearchActive {
  const UserSearchInprogress({required super.userSearchs});
}

class UserSearchLoadMore extends UserSearchActive {
  const UserSearchLoadMore({required super.userSearchs});
}

class UserSearchDone extends UserSearchActive {
  const UserSearchDone({required super.userSearchs});
}
