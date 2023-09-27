// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/features/home/widgets/dialog_prepare_meeting.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting_role.dart';
import 'package:waterbus/features/meeting/domain/entities/participant.dart';
import 'package:waterbus/features/meeting/domain/usecases/clean_all_recent_joined.dart';
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
  final CleanAllRecentJoined _cleanAllRecentJoined;
  final CreateMeeting _createMeeting;
  // ignore: unused_field
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
    this._cleanAllRecentJoined,
    this._createMeeting,
    this._joinMeeting,
    this._updateMeeting,
    this._getInfoMeeting,
    this._leaveMeeting,
  ) : super(MeetingInitial()) {
    on<MeetingEvent>((event, emit) async {
      if (event is GetRecentJoinedEvent) {
        await _handleGetRecentJoined();

        emit(_joinedMeeting);
      }

      if (event is CleanAllRecentJoinedEvent) {
        await _handleCleanAllRecentJoined();

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
        final int indexOfMeetingInRecent = _recentMeetings.indexWhere(
          (meeting) => meeting.code == event.meeting.code,
        );

        // Will be take the meeting object in recent joined
        if (indexOfMeetingInRecent != -1) {
          _currentMeeting = _recentMeetings[indexOfMeetingInRecent];

          final int indexOfParticipant =
              _currentMeeting!.participants.indexWhere(
            (participant) =>
                participant.isMe && participant.role == MeetingRole.host,
          );

          final bool isHost = indexOfParticipant != -1;

          // Will join directly if the participant is the host of room
          if (isHost) {
            _myParticipant = _currentMeeting!.participants[indexOfParticipant];

            emit(_joinedMeeting);
            AppNavigator.push(Routes.meetingRoute);
            return;
          }
        }

        _currentMeeting = event.meeting;

        emit(_preJoinMeeting);
        AppNavigator.push(Routes.meetingRoute);
      }

      if (event is JoinMeetingWithPasswordEvent) {
        if (_currentMeeting == null) return;

        final bool isJoinSucceed = await _handleJoinWithPassword(event);

        AppNavigator.pop();

        if (isJoinSucceed) {
          emit(_joinedMeeting);
        }
      }

      if (event is GetInfoMeetingEvent) {
        await _handleGetInfoMeeting(event);
      }

      if (event is LeaveMeetingEvent) {
        await _handleLeaveMeeting(event);
      }

      if (event is DisplayDialogMeetingEvent) {
        _displayDialogJoinMeeting(event.meeting);
      }
    });
  }

  // MARK: state
  JoinedMeeting get _joinedMeeting => JoinedMeeting(
        meeting: _currentMeeting,
        recentMeetings: _recentMeetings,
      );

  PreJoinMeeting get _preJoinMeeting => PreJoinMeeting(
        meeting: _currentMeeting,
      );

  // MARK: Private
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
      _myParticipant = r.participants.first;
      return _currentMeeting = r;
    });
  }

  Future<bool> _handleJoinWithPassword(
    JoinMeetingWithPasswordEvent event,
  ) async {
    final Either<Failure, Meeting> meeting = await _joinMeeting.call(
      CreateMeetingParams(
        meeting: _currentMeeting!,
        password: event.password,
      ),
    );

    return meeting.fold((l) => false, (r) {
      _currentMeeting = r;

      _recentMeetings.removeWhere((meeting) => meeting.id == r.id);

      _recentMeetings.insert(0, r);

      final int indexOfMyParticipant = r.participants.lastIndexWhere(
        (participant) => participant.isMe,
      );

      if (indexOfMyParticipant != -1) {
        _myParticipant = r.participants[indexOfMyParticipant];
      }

      return true;
    });
  }

  Future<Meeting?> _handleGetInfoMeeting(GetInfoMeetingEvent event) async {
    final Either<Failure, Meeting> meeting = await _getInfoMeeting.call(
      GetMeetingParams(code: event.roomCode),
    );

    AppNavigator.pop();

    return meeting.fold((l) => null, (r) {
      _displayDialogJoinMeeting(r);
      return r;
    });
  }

  Future<void> _handleUpdateMeeting(UpdateMeetingEvent event) async {
    if (_currentMeeting == null) return;

    final Either<Failure, Meeting> meeting = await _updateMeeting.call(
      CreateMeetingParams(
        meeting: _currentMeeting!.copyWith(title: event.roomName),
        password: event.password,
      ),
    );

    AppNavigator.pop();

    meeting.fold((l) => null, (r) {
      AppNavigator.popUntil(Routes.meetingRoute);
      final int indexOfMeeting = _recentMeetings.indexWhere(
        (meeting) => r.id == meeting.id,
      );

      if (indexOfMeeting != -1) {
        _recentMeetings[indexOfMeeting] = r;
      }

      return _currentMeeting = r;
    });
  }

  Future<void> _handleLeaveMeeting(LeaveMeetingEvent event) async {
    if (_currentMeeting == null || _myParticipant == null) return;

    final Either<Failure, Meeting> isLeaveSucceed = await _leaveMeeting.call(
      LeaveMeetingParams(
        code: _currentMeeting!.code,
        participantId: _myParticipant!.id,
      ),
    );

    AppNavigator.pop();

    isLeaveSucceed.fold((l) => null, (r) {
      _currentMeeting = null;
      _myParticipant = null;

      _findAndModifyRecent(r);

      AppNavigator.pop();
    });
  }

  void _displayDialogJoinMeeting(Meeting meeting) {
    showDialogWaterbus(
      alignment: Alignment.bottomCenter,
      paddingBottom: 56.sp,
      child: DialogPrepareMeeting(
        meeting: meeting,
        handleJoinMeeting: () {
          AppNavigator.popUntil(Routes.rootRoute);
          add(JoinMeetingEvent(meeting: meeting));
        },
      ),
    );
  }

  void _findAndModifyRecent(Meeting meeting) {
    final int indexOfMeeting = _recentMeetings.indexWhere(
      (m) => m.id == meeting.id,
    );

    if (indexOfMeeting == -1) return;

    _recentMeetings[indexOfMeeting] = meeting;
  }
}
