part of 'recent_joined_bloc.dart';

sealed class RecentJoinedEvent extends Equatable {
  const RecentJoinedEvent();

  @override
  List<Object> get props => [];
}

class RecentJoinedGet extends RecentJoinedEvent {}

class RecentJoinedInsert extends RecentJoinedEvent {
  final Meeting meeting;
  const RecentJoinedInsert({required this.meeting});
}

class RecentJoinedUpdate extends RecentJoinedEvent {
  final Meeting meeting;
  const RecentJoinedUpdate({required this.meeting});
}

class RecentJoinedRemove extends RecentJoinedEvent {
  final int meetingId;
  const RecentJoinedRemove({required this.meetingId});
}

class RecentJoinedClean extends RecentJoinedEvent {}
