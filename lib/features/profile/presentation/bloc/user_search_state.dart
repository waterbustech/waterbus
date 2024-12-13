part of 'user_search_bloc.dart';

sealed class UserSearchState extends Equatable {
  const UserSearchState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserSearchState {}

class UserSearchActived extends UserSearchState {
  final List<User> userSearchs;

  const UserSearchActived({
    required this.userSearchs,
  });

  @override
  List<Object> get props => [userSearchs];
}

class UserSearchInprogress extends UserSearchActived {
  const UserSearchInprogress({required super.userSearchs});
}

class UserSearchLoadMore extends UserSearchActived {
  const UserSearchLoadMore({required super.userSearchs});
}

class UserSearchDone extends UserSearchActived {
  const UserSearchDone({required super.userSearchs});
}
