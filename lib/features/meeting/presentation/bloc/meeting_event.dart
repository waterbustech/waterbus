part of 'meeting_bloc.dart';

sealed class MeetingEvent extends Equatable {
  const MeetingEvent();

  @override
  List<Object> get props => [];
}

class GetRecentJoinedEvent extends MeetingEvent {}

class CreateMeetingEvent extends MeetingEvent {
  final String roomName;
  final String password;
  const CreateMeetingEvent({required this.roomName, required this.password});
}

class UpdateMeetingEvent extends MeetingEvent {
  final String roomName;
  final String password;
  const UpdateMeetingEvent({required this.roomName, required this.password});
}

class JoinMeetingEvent extends MeetingEvent {
  final int roomCode;
  final String password;
  const JoinMeetingEvent({required this.roomCode, required this.password});
}

class GetInfoMeetingEvent extends MeetingEvent {
  final int roomCode;
  const GetInfoMeetingEvent({required this.roomCode});
}

class LeaveMeetingEvent extends MeetingEvent {}
