part of 'recent_joined_bloc.dart';

sealed class RecentJoinedEvent extends Equatable {
  const RecentJoinedEvent();

  @override
  List<Object> get props => [];
}

class RecentJoinedStarted extends RecentJoinedEvent {}

class RecentJoinedInserted extends RecentJoinedEvent {
  final Meeting meeting;
  const RecentJoinedInserted({required this.meeting});
}

class RecentJoinedUpdated extends RecentJoinedEvent {
  final Meeting meeting;
  const RecentJoinedUpdated({required this.meeting});
}

class RecentJoinedRemoved extends RecentJoinedEvent {
  final int meetingId;
  const RecentJoinedRemoved({required this.meetingId});
}

class RecentJoinedCleaned extends RecentJoinedEvent {}
