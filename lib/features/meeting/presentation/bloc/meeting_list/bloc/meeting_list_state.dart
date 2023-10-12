part of 'meeting_list_bloc.dart';

abstract class MeetingListState extends Equatable {
  const MeetingListState({
    this.recentMeetings = const [],
  });

  final List<Meeting> recentMeetings;
}

final class MeetingListInitial extends MeetingListState {
  @override
  List<Object?> get props => [];
}

class GetDoneMeetings extends MeetingListState {
  const GetDoneMeetings({
    required super.recentMeetings,
  });

  @override
  List<Object?> get props => [
        recentMeetings,
        identityHashCode(this),
      ];
}
