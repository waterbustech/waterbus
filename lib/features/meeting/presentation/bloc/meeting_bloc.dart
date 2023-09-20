// Package imports:
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/entities/participant.dart';
import 'package:waterbus/features/meeting/domain/usecases/create_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/get_info_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/get_recent_joined.dart';
import 'package:waterbus/features/meeting/domain/usecases/join_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/leave_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/update_meeting.dart';

part 'meeting_event.dart';
part 'meeting_state.dart';

@injectable
class MeetingBloc extends Bloc<MeetingEvent, MeetingState> {
  final GetRecentJoined _recentJoined;
  final CreateMeeting _createMeeting;
  final JoinMeeting _joinMeeting;
  final UpdateMeeting _updateMeeting;
  final GetInfoMeeting _getInfoMeeting;
  final LeaveMeeting _leaveMeeting;

  // MARK: private
  Meeting? _currentMeeting;
  Participant? _myParticipant;
  final List<Meeting> _recentMeetings = [];

  MeetingBloc(
    this._recentJoined,
    this._createMeeting,
    this._joinMeeting,
    this._updateMeeting,
    this._getInfoMeeting,
    this._leaveMeeting,
  ) : super(MeetingInitial()) {
    on<MeetingEvent>((event, emit) async {
      if (event is GetRecentJoinedEvent) {
        await _getRecentJoined(event);

        emit(_joinedMeeting);
      }

      if (event is CreateMeetingEvent) {
        await _handleCreateMeeting(event);

        if (_currentMeeting != null) {
          emit(_joinedMeeting);
        }
      }

      if (event is UpdateMeetingEvent) {
        await _handleUpdateMeeting(event);

        if (_currentMeeting != null) {
          emit(_joinedMeeting);
        }
      }

      if (event is JoinMeetingEvent) {
        await _handleJoinMeeting(event);
      }

      if (event is GetInfoMeetingEvent) {
        await _handleGetInfoMeeting(event);
      }

      if (event is LeaveMeetingEvent) {
        await _handleLeaveMeeting(event);
      }
    });
  }

  // MARK: state
  JoinedMeeting get _joinedMeeting => JoinedMeeting(
        meeting: _currentMeeting,
        recentMeetings: _recentMeetings,
      );

  // MARK: Private
  Future<void> _getRecentJoined(GetRecentJoinedEvent event) async {
    final Either<Failure, List<Meeting>> meetings =
        await _recentJoined.call(null);

    meetings.fold((l) => null, (r) {
      return _recentMeetings.addAll(r);
    });
  }

  Future<void> _handleCreateMeeting(CreateMeetingEvent event) async {
    final Either<Failure, Meeting> meeting = await _createMeeting.call(
      CreateMeetingParams(
        meeting: Meeting(title: event.roomName),
        password: event.password,
      ),
    );

    AppNavigator.pop();

    meeting.fold((l) => null, (r) {
      AppNavigator.replaceWith(Routes.meetingRoute);
      _recentMeetings.insert(0, r);
      _myParticipant = r.users.first;
      return _currentMeeting = r;
    });
  }

  Future<Meeting?> _handleGetInfoMeeting(GetInfoMeetingEvent event) async {
    final Either<Failure, Meeting> meeting = await _getInfoMeeting.call(
      GetMeetingParams(code: event.roomCode),
    );

    return meeting.fold((l) => null, (r) => r);
  }

  Future<void> _handleUpdateMeeting(UpdateMeetingEvent event) async {
    final Either<Failure, Meeting> meeting = await _updateMeeting.call(
      CreateMeetingParams(
        meeting: Meeting(title: event.roomName),
        password: event.password,
      ),
    );

    meeting.fold((l) => null, (r) {
      _currentMeeting = r;
    });
  }

  Future<void> _handleJoinMeeting(JoinMeetingEvent event) async {
    final Either<Failure, Meeting> meeting = await _joinMeeting.call(
      CreateMeetingParams(
        meeting: Meeting(title: '', code: event.roomCode),
        password: event.password,
      ),
    );

    meeting.fold((l) => null, (r) => _currentMeeting = r);
  }

  Future<void> _handleLeaveMeeting(LeaveMeetingEvent event) async {
    if (_currentMeeting == null || _myParticipant == null) return;

    final Either<Failure, bool> isLeaveSucceed = await _leaveMeeting.call(
      LeaveMeetingParams(
        code: _currentMeeting!.code,
        participantId: _myParticipant!.id,
      ),
    );

    isLeaveSucceed.fold((l) => null, (r) {
      _currentMeeting = null;
      _myParticipant = null;
    });
  }
}
