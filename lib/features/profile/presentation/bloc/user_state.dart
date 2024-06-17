part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

class UserSearchingState extends UserState {
  final User user;
  final CheckUsernameStatus checkUsernameStatus;
  final List<User> userSearchs;

  const UserSearchingState({
    required this.user,
    required this.checkUsernameStatus,
    required this.userSearchs,
  });

  @override
  List<Object> get props => [user, checkUsernameStatus, userSearchs];
}

class UserGetDone extends UserState {
  final User user;
  final CheckUsernameStatus checkUsernameStatus;
  final List<User> userSearchs;

  const UserGetDone({
    required this.user,
    required this.checkUsernameStatus,
    required this.userSearchs,
  });

  @override
  List<Object> get props => [user, checkUsernameStatus, userSearchs];
}
