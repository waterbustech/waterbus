part of 'recent_joined_bloc.dart';

sealed class RecentJoinedEvent extends Equatable {
  const RecentJoinedEvent();

  @override
  List<Object> get props => [];
}

class RecentJoinedStarted extends RecentJoinedEvent {}

class RecentJoinedInserted extends RecentJoinedEvent {
  final Room room;
  const RecentJoinedInserted({required this.room});
}

class RecentJoinedUpdated extends RecentJoinedEvent {
  final Room room;
  const RecentJoinedUpdated({required this.room});
}

class RecentJoinedRemoved extends RecentJoinedEvent {
  final int roomId;
  const RecentJoinedRemoved({required this.roomId});
}

class RecentJoinedCleaned extends RecentJoinedEvent {}
