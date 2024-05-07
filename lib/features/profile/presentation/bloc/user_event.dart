part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetProfileEvent extends UserEvent {}

class UpdateProfileEvent extends UserEvent {
  final String fullName;
  final String? bio;
  final String? avatar;
  const UpdateProfileEvent({
    required this.fullName,
    this.avatar,
    this.bio,
  });
}

class UpdateAvatarEvent extends UserEvent {
  final Uint8List image;
  const UpdateAvatarEvent({required this.image});
}

class CheckUsernameEvent extends UserEvent {
  final String username;
  const CheckUsernameEvent({required this.username});
}

class UpdateUsernameEvent extends UserEvent {
  final String username;
  const UpdateUsernameEvent({required this.username});
}

class CleanProfileEvent extends UserEvent {}
