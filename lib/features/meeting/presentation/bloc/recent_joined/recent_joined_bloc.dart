import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus_sdk/types/models/meeting_model.dart';

import 'package:waterbus/features/meeting/data/datasources/meeting_local_datasource.dart';

part 'recent_joined_event.dart';
part 'recent_joined_state.dart';

@injectable
class RecentJoinedBloc extends Bloc<RecentJoinedEvent, RecentJoinedState> {
  final List<Meeting> _recentMeetings = [];
  final MeetingLocalDataSource _localDataSource;

  RecentJoinedBloc(
    this._localDataSource,
  ) : super(RecentJoinedInitial()) {
    on<RecentJoinedEvent>(
      (event, emit) async {
        if (event is RecentJoinedGet) {
          _handleGetRecentJoined();

          emit(_recentJoinedDone);
        }

        if (event is RecentJoinedInsert) {
          _insertMeeting(event.meeting);

          emit(_recentJoinedDone);
        }

        if (event is RecentJoinedUpdate) {
          _findAndModifyRecent(event.meeting);

          emit(_recentJoinedDone);
        }

        if (event is RecentJoinedRemove) {
          _removeMeeting(event.meetingId);

          emit(_recentJoinedDone);
        }

        if (event is RecentJoinedClean) {
          _handleCleanAllRecentJoined();

          emit(_recentJoinedDone);
        }
      },
    );
  }

  // MARK: state
  RecentJoinedDone get _recentJoinedDone {
    _recentMeetings.sort((pre, cur) {
      return cur.latestJoinedTime.compareTo(pre.latestJoinedTime);
    });

    return RecentJoinedDone(recentMeetings: _recentMeetings);
  }

  // MARK: private functions
  void _handleGetRecentJoined() {
    final List<Meeting> meetings = _localDataSource.meetings;

    if (meetings.isNotEmpty) {
      _recentMeetings.clear();
      _recentMeetings.addAll(meetings);
    }
  }

  void _handleCleanAllRecentJoined() {
    _localDataSource.removeAll();
    _recentMeetings.clear();
  }

  void _insertMeeting(Meeting meet) {
    final int indexOfMeeting = _recentMeetings.indexWhere(
      (meeting) => meet.id == meeting.id,
    );

    if (indexOfMeeting > -1) {
      _recentMeetings.removeAt(indexOfMeeting);
    }

    _recentMeetings.insert(0, meet);
  }

  void _removeMeeting(int meetingId) {
    final int indexOfMeeting = _recentMeetings.indexWhere(
      (meeting) => meeting.id == meetingId,
    );

    if (indexOfMeeting > -1) {
      _localDataSource.removeMeeting(_recentMeetings[indexOfMeeting].code);
      _recentMeetings.removeAt(indexOfMeeting);
    }
  }

  void _findAndModifyRecent(Meeting meeting) {
    final int indexOfMeeting = _recentMeetings.indexWhere(
      (m) => m.id == meeting.id,
    );

    if (indexOfMeeting == -1) return;

    _recentMeetings[indexOfMeeting] = meeting.copyWith(
      latestJoinedAt: _recentMeetings[indexOfMeeting].latestJoinedAt,
    );
  }

  // MARK: export
  List<Meeting> get recentMeetings => _recentMeetings;
}
