// Package imports:
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/entities/participant.dart';
import 'package:waterbus/features/meeting/domain/usecases/create_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/get_info_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/join_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/leave_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/update_meeting.dart';

part 'meeting_event.dart';
part 'meeting_state.dart';

@injectable
class MeetingBloc extends Bloc<MeetingEvent, MeetingState> {
  final CreateMeeting _createMeeting;
  final JoinMeeting _joinMeeting;
  final UpdateMeeting _updateMeeting;
  final GetInfoMeeting _getInfoMeeting;
  final LeaveMeeting _leaveMeeting;

  // MARK: private
  Meeting? _currentMeeting;

  MeetingBloc(
    this._createMeeting,
    this._joinMeeting,
    this._updateMeeting,
    this._getInfoMeeting,
    this._leaveMeeting,
  ) : super(MeetingInitial()) {
    on<MeetingEvent>((event, emit) async {
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
      );

  // MARK: Private
  Future<void> _handleCreateMeeting(CreateMeetingEvent event) async {
    final Either<Failure, Meeting> meeting = await _createMeeting.call(
      CreateMeetingParams(
        meeting: Meeting(title: event.roomName),
        password: event.password,
      ),
    );

    meeting.fold((l) => null, (r) {
      _currentMeeting = r;
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
        meeting: Meeting(title: '', code: event.roomCode.toString()),
        password: event.password,
      ),
    );

    meeting.fold((l) => null, (r) => _currentMeeting = r);
  }

  Future<void> _handleLeaveMeeting(LeaveMeetingEvent event) async {
    if (_currentMeeting == null) return;

    final int indexOfParticipant = _currentMeeting!.users.indexWhere(
      (user) => user.user.userName == AppBloc.userBloc.user?.userName,
    );

    if (indexOfParticipant == -1) return;

    final Participant participant = _currentMeeting!.users[indexOfParticipant];

    final Either<Failure, bool> isLeaveSucceed = await _leaveMeeting.call(
      LeaveMeetingParams(
        code: int.parse(_currentMeeting!.code),
        participantId: participant.id,
      ),
    );

    isLeaveSucceed.fold((l) => null, (r) {
      _currentMeeting = null;
    });
  }
}
