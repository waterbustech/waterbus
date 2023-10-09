part of 'meeting_list_bloc.dart';

sealed class MeetingListEvent extends Equatable {
  const MeetingListEvent();

  @override
  List<Object> get props => [];
}

class GetRecentJoinedEvent extends MeetingListEvent {}

class InsertRecentJoinEvent extends MeetingListEvent {
  final Meeting meeting;
  const InsertRecentJoinEvent({required this.meeting});
}

class UpdateRecentJoinEvent extends MeetingListEvent {
  final Meeting meeting;
  const UpdateRecentJoinEvent({required this.meeting});
}

class CleanAllRecentJoinedEvent extends MeetingListEvent {}
