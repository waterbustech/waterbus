part of 'meeting_bloc.dart';

abstract class MeetingState {
  const MeetingState({
    this.meeting,
    this.participant,
    this.callState,
  });

  final Meeting? meeting;
  final Participant? participant;
  final CallState? callState;

  // @override
  // List<Object?> get props => [meeting, participant, callState];
}

class MeetingInitial extends MeetingState {
  const MeetingInitial();
}

class PreJoinMeeting extends MeetingState {
  const PreJoinMeeting({
    required super.meeting,
    required super.participant,
  });
}

class JoinedMeeting extends MeetingState {
  const JoinedMeeting({
    required super.meeting,
    required super.participant,
    required super.callState,
  });
}
