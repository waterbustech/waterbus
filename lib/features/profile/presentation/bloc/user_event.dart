part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserFetched extends UserEvent {}

class UserUpdated extends UserEvent {
  final String fullName;
  final String? bio;
  final String? avatar;
  const UserUpdated({
    required this.fullName,
    this.avatar,
    this.bio,
  });
}

class UserAvatarUpdated extends UserEvent {
  final Uint8List image;
  const UserAvatarUpdated({required this.image});
}

class UserUsernameChecked extends UserEvent {
  final String username;
  const UserUsernameChecked({required this.username});
}

class UserUsernameUpdated extends UserEvent {
  final String username;
  const UserUsernameUpdated({required this.username});
}

class UserCleaned extends UserEvent {}
