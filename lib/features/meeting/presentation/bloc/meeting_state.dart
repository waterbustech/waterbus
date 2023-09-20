part of 'meeting_bloc.dart';

sealed class MeetingState extends Equatable {
  const MeetingState();

  @override
  List<Object?> get props => [];
}

final class MeetingInitial extends MeetingState {}

class CheckingMeeting extends MeetingState {}

class CheckedMeeting extends MeetingState {}

class PrepareJoinMeeting extends MeetingState {}

class JoinedMeeting extends MeetingState {
  final Meeting? meeting;
  final List<Meeting> recentMeetings;
  const JoinedMeeting({required this.meeting, required this.recentMeetings});

  @override
  List<Object?> get props => [meeting, recentMeetings];
}
