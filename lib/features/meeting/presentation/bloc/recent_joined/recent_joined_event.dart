part of 'recent_joined_bloc.dart';

sealed class MeetingListEvent extends Equatable {
  const MeetingListEvent();

  @override
  List<Object> get props => [];
}

class GetRecentJoinedEvent extends MeetingListEvent {}

class InsertRecentJoinedEvent extends MeetingListEvent {
  final Meeting meeting;
  const InsertRecentJoinedEvent({
    required this.meeting,
  });
}

class UpdateRecentJoinedEvent extends MeetingListEvent {
  final Meeting meeting;
  const UpdateRecentJoinedEvent({required this.meeting});
}

class RemoveRecentJoinedEvent extends MeetingListEvent {
  final int meetingId;
  const RemoveRecentJoinedEvent({required this.meetingId});
}

class CleanAllRecentJoinedEvent extends MeetingListEvent {}
