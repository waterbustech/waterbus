// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/home/widgets/dialog_prepare_meeting.dart';
import 'package:waterbus/features/meeting/domain/entities/call_state.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting_role.dart';
import 'package:waterbus/features/meeting/domain/entities/participant.dart';
import 'package:waterbus/features/meeting/domain/entities/status_enum.dart';
import 'package:waterbus/features/meeting/domain/usecases/create_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/get_info_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/get_participant.dart';
import 'package:waterbus/features/meeting/domain/usecases/join_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/leave_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/update_meeting.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting_list/bloc/meeting_list_bloc.dart';
import 'package:waterbus/services/webrtc/webrtc_interface.dart';

part 'meeting_event.dart';
part 'meeting_state.dart';

@injectable
class MeetingBloc extends Bloc<MeetingEvent, MeetingState> {
  final CreateMeeting _createMeeting;
  final JoinMeeting _joinMeeting;
  final UpdateMeeting _updateMeeting;
  final GetInfoMeeting _getInfoMeeting;
  final LeaveMeeting _leaveMeeting;
  final GetParticipant _getParticipant;
  // ignore: unused_field
  final WaterbusWebRTCManager _rtcManager;

  // MARK: private
  Meeting? _currentMeeting;
  Participant? _myParticipant;

  MeetingBloc(
    this._createMeeting,
    this._joinMeeting,
    this._updateMeeting,
    this._getInfoMeeting,
    this._leaveMeeting,
    this._getParticipant,
    this._rtcManager,
  ) : super(const MeetingInitial()) {
    on<MeetingEvent>(
      transformer: sequential(),
      (event, emit) async {
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
          final int indexOfMeetingInRecent =
              AppBloc.meetingListBloc.recentMeetings.indexWhere(
            (meeting) => meeting.code == event.meeting.code,
          );

          // Will be take the meeting object in recent joined
          if (indexOfMeetingInRecent != -1) {
            _currentMeeting =
                AppBloc.meetingListBloc.recentMeetings[indexOfMeetingInRecent];

            final int indexOfParticipant =
                _currentMeeting!.participants.indexWhere(
              (participant) =>
                  participant.isMe && participant.role == MeetingRole.host,
            );

            final bool isHost = indexOfParticipant != -1;

            // Will join directly if the participant is the host of room
            if (isHost) {
              _myParticipant =
                  _currentMeeting!.participants[indexOfParticipant];

              displayLoadingLayer();

              add(
                const JoinMeetingWithPasswordEvent(password: '', isHost: true),
              );
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

          if (isJoinSucceed) {
            await _initialWebRTCManager(
              roomCode: _currentMeeting!.code.toString(),
              participantId: _myParticipant!.id,
            );
          }

          AppNavigator.pop();

          if (isJoinSucceed) {
            emit(_joinedMeeting);

            if (event.isHost) {
              AppNavigator.push(Routes.meetingRoute);
            }
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

        // During meeting
        if (event is EstablishBroadcastSuccessEvent) {
          await _handleEstablishBroadcastSuccess(event);

          if (_currentMeeting != null) {
            emit(_joinedMeeting);
          }
        }

        if (event is EstablishReceiverSuccessEvent) {
          await _handleEstablishReceiverSuccess(event);

          if (_currentMeeting != null) {
            emit(_joinedMeeting);
          }
        }

        if (event is NewParticipantEvent) {
          await _handleNewParticipant(event);

          if (_currentMeeting != null) {
            emit(_joinedMeeting);
          }
        }

        if (event is ParticipantHasLeftEvent) {
          await _handleParticipantHasLeft(event);

          if (_currentMeeting != null) {
            emit(_joinedMeeting);
          }
        }

        if (event is NewBroadcastCandidateEvent) {
          _rtcManager.addPublisherCandidate(event.candidate);
        }

        if (event is NewReceiverCandidateEvent) {
          _rtcManager.addSubscriberCandidate(event.targetId, event.candidate);
        }

        if (event is UpdateNewMeetingEvent) {
          if (_currentMeeting != null) {
            emit(_joinedMeeting);
          }
        }
      },
    );
  }

  // MARK: state
  JoinedMeeting get _joinedMeeting => JoinedMeeting(
        meeting: _currentMeeting,
        participant: _myParticipant,
        callState: _rtcManager.callState(),
      );

  PreJoinMeeting get _preJoinMeeting => PreJoinMeeting(
        meeting: _currentMeeting,
        participant: _myParticipant,
      );

  // MARK: Private
  Future<void> _handleCreateMeeting(CreateMeetingEvent event) async {
    final Either<Failure, Meeting> meeting = await _createMeeting.call(
      CreateMeetingParams(
        meeting: Meeting(title: event.roomName),
        password: event.password,
      ),
    );

    AppNavigator.pop();

    meeting.fold((l) => null, (r) async {
      AppNavigator.replaceWith(Routes.meetingRoute);
      AppBloc.meetingListBloc.add(InsertRecentJoinEvent(meeting: r));
      _myParticipant = r.participants.first;

      await _initialWebRTCManager(
        roomCode: r.code.toString(),
        participantId: _myParticipant!.id,
      );

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

      AppBloc.meetingListBloc.add(InsertRecentJoinEvent(meeting: r));

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
      AppBloc.meetingListBloc.add(InsertRecentJoinEvent(meeting: r));

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

      AppBloc.meetingListBloc.add(UpdateRecentJoinEvent(meeting: r));

      _rtcManager.dispose();

      AppNavigator.pop();
    });
  }

  Future<void> _handleEstablishBroadcastSuccess(
    EstablishBroadcastSuccessEvent event,
  ) async {
    await _rtcManager.setBroadcastRemoteSdp(event.sdp);
    await _rtcManager.establishReceiverStream(event.participants);
  }

  Future<void> _handleEstablishReceiverSuccess(
    EstablishReceiverSuccessEvent event,
  ) async {
    await _rtcManager.setReceiverRemoteSdp(
      event.participantId,
      event.sdp,
    );
  }

  Future<void> _handleNewParticipant(NewParticipantEvent event) async {
    if (_currentMeeting == null) return;

    _rtcManager.newParticipant(event.participantId);

    final List<Participant> participants = _currentMeeting!.participants;

    final int indexOfParticipant = participants.indexWhere(
      (participant) => participant.id == int.parse(event.participantId),
    );

    if (indexOfParticipant != -1) {
      participants[indexOfParticipant] =
          participants[indexOfParticipant].copyWith(
        status: StatusEnum.active,
      );

      _currentMeeting = _currentMeeting!.copyWith(
        participants: participants,
      );

      AppBloc.meetingListBloc.add(
        UpdateRecentJoinEvent(meeting: _currentMeeting!),
      );

      return;
    }

    final Either<Failure, Participant> participant = await _getParticipant.call(
      GetPariticipantParams(
        participantId: int.parse(event.participantId),
      ),
    );

    participant.fold((l) => null, (r) {
      participants.add(r);
      _currentMeeting = _currentMeeting!.copyWith(
        participants: participants,
      );

      AppBloc.meetingListBloc.add(
        UpdateRecentJoinEvent(meeting: _currentMeeting!),
      );

      return r;
    });
  }

  Future<void> _handleParticipantHasLeft(
    ParticipantHasLeftEvent event,
  ) async {
    if (_currentMeeting == null) return;

    await _rtcManager.participantHasLeft(event.participantId);

    final List<Participant> participants = _currentMeeting!.participants;

    final int indexOfParticipant = participants.indexWhere(
      (participant) => participant.id == int.parse(event.participantId),
    );

    if (indexOfParticipant != -1) {
      participants[indexOfParticipant] =
          participants[indexOfParticipant].copyWith(
        status: StatusEnum.inactive,
      );

      _currentMeeting = _currentMeeting!.copyWith(
        participants: participants,
      );

      AppBloc.meetingListBloc.add(
        UpdateRecentJoinEvent(meeting: _currentMeeting!),
      );
    }
  }

  Future<void> _initialWebRTCManager({
    required String roomCode,
    required int participantId,
  }) async {
    await _rtcManager.startBroadcastLocalMedia(
      roomId: roomCode,
      participantId: participantId,
    );
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
}
