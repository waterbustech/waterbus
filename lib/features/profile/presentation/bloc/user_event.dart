part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetProfileEvent extends UserEvent {}

class UpdateProfileEvent extends UserEvent {
  final String fullName;
  final String? avatar;
  const UpdateProfileEvent({required this.fullName, this.avatar});
}

class UpdateAvatarEvent extends UserEvent {
  final Uint8List image;
  const UpdateAvatarEvent({required this.image});
}

class CleanProfileEvent extends UserEvent {}
