part of 'meeting_bloc.dart';

abstract class MeetingState extends Equatable {
  const MeetingState({
    this.meeting,
    this.participant,
    this.recentMeetings = const [],
    this.callState,
  });

  final Meeting? meeting;
  final Participant? participant;
  final List<Meeting> recentMeetings;
  final CallState? callState;

  @override
  List<Object?> get props => [meeting, participant, recentMeetings, callState];
}

class MeetingInitial extends MeetingState {
  const MeetingInitial();
}

class PreJoinMeeting extends MeetingState {
  const PreJoinMeeting({
    required super.meeting,
    required super.participant,
    required super.recentMeetings,
  });
}

class JoinedMeeting extends MeetingState {
  const JoinedMeeting({
    required super.meeting,
    required super.participant,
    required super.recentMeetings,
    required super.callState,
  });
}
