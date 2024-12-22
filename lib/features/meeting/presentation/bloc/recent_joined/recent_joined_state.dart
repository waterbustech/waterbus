part of 'recent_joined_bloc.dart';

abstract class RecentJoinedState extends Equatable {
  final List<Meeting> recentMeetings;
  const RecentJoinedState({this.recentMeetings = const []});

  @override
  List<Object?> get props => [recentMeetings, identityHashCode(this)];
}

final class RecentJoinedInitial extends RecentJoinedState {}

class RecentJoinedDone extends RecentJoinedState {
  const RecentJoinedDone({required super.recentMeetings});
}
