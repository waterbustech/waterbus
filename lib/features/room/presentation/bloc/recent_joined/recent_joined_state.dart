part of 'recent_joined_bloc.dart';

abstract class RecentJoinedState extends Equatable {
  final List<Room> recentRooms;
  const RecentJoinedState({this.recentRooms = const []});

  @override
  List<Object?> get props => [recentRooms, identityHashCode(this)];
}

final class RecentJoinedInitial extends RecentJoinedState {}

class RecentJoinedDone extends RecentJoinedState {
  const RecentJoinedDone({required super.recentRooms});
}
