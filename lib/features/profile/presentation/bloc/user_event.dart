part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetProfileEvent extends UserEvent {}

class UpdateProfileEvent extends UserEvent {
  final User user;
  const UpdateProfileEvent({required this.user});
}

class UpdateAvatarEvent extends UserEvent {
  final File image;
  const UpdateAvatarEvent({required this.image});
}

class CleanProfileEvent extends UserEvent {}
