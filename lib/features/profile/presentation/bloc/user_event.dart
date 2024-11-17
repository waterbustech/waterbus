part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserGet extends UserEvent {}

class UserUpdate extends UserEvent {
  final String fullName;
  final String? bio;
  final String? avatar;
  const UserUpdate({
    required this.fullName,
    this.avatar,
    this.bio,
  });
}

class UserUpdateAvatar extends UserEvent {
  final Uint8List image;
  const UserUpdateAvatar({required this.image});
}

class UserCheckUsername extends UserEvent {
  final String username;
  const UserCheckUsername({required this.username});
}

class UserUpdateUsername extends UserEvent {
  final String username;
  const UserUpdateUsername({required this.username});
}

class UserClean extends UserEvent {}
