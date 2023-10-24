// Package imports:
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/clean_all_recent_joined.dart';
import 'package:waterbus/features/meeting/domain/usecases/get_recent_joined.dart';

part 'meeting_list_event.dart';
part 'meeting_list_state.dart';

@injectable
class MeetingListBloc extends Bloc<MeetingListEvent, MeetingListState> {
  final GetRecentJoined _recentJoined;
  final CleanAllRecentJoined _cleanAllRecentJoined;

  final List<Meeting> _recentMeetings = [];

  MeetingListBloc(
    this._recentJoined,
    this._cleanAllRecentJoined,
  ) : super(MeetingListInitial()) {
    on<MeetingListEvent>(
      (event, emit) async {
        if (event is GetRecentJoinedEvent) {
          await _handleGetRecentJoined();

          emit(_getDoneMeetings);
        }

        if (event is InsertRecentJoinEvent) {
          _insertMeeting(event.meeting);

          emit(_getDoneMeetings);
        }

        if (event is UpdateRecentJoinEvent) {
          _findAndModifyRecent(event.meeting);

          emit(_getDoneMeetings);
        }

        if (event is CleanAllRecentJoinedEvent) {
          await _handleCleanAllRecentJoined();

          emit(_getDoneMeetings);
        }
      },
    );
  }

  // MARK: state
  GetDoneMeetings get _getDoneMeetings {
    _recentMeetings.sort(
      (pre, cur) {
        return cur.latestJoinedTime.compareTo(pre.latestJoinedTime);
      },
    );

    return GetDoneMeetings(
      recentMeetings: _recentMeetings,
    );
  }

  // MARK: private functions
  Future<void> _handleGetRecentJoined() async {
    final Either<Failure, List<Meeting>> meetings =
        await _recentJoined.call(null);

    meetings.fold((l) => null, (r) {
      _recentMeetings.clear();
      return _recentMeetings.addAll(r);
    });
  }

  Future<void> _handleCleanAllRecentJoined() async {
    final Either<Failure, bool> isCleanSucceed =
        await _cleanAllRecentJoined.call(null);

    if (isCleanSucceed.isRight()) {
      _recentMeetings.clear();
    }
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
