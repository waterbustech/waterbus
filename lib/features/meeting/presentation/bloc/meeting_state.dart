part of 'meeting_bloc.dart';

sealed class MeetingState extends Equatable {
  const MeetingState();

  @override
  List<Object?> get props => [];
}

final class MeetingInitial extends MeetingState {}

class PreJoinMeeting extends MeetingState {
  final Meeting? meeting;
  const PreJoinMeeting({required this.meeting});

  @override
  List<Object?> get props => [meeting];
}

class JoinedMeeting extends MeetingState {
  final Meeting? meeting;
  final Participant? participant;
  final List<Meeting> recentMeetings;
  const JoinedMeeting({
    required this.meeting,
    required this.recentMeetings,
    required this.participant,
  });

  @override
  List<Object?> get props => [meeting, recentMeetings, participant];
}
