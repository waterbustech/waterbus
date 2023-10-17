part of 'meeting_list_bloc.dart';

abstract class MeetingListState extends Equatable {
  const MeetingListState({
    this.recentMeetings = const [],
  });

  final List<Meeting> recentMeetings;

  @override
  List<Object?> get props => [
        recentMeetings,
        identityHashCode(this),
      ];
}

final class MeetingListInitial extends MeetingListState {}

class GetDoneMeetings extends MeetingListState {
  const GetDoneMeetings({
    required super.recentMeetings,
  });
}
