// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/home/widgets/dialog_prepare_meeting.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting_role.dart';
import 'package:waterbus/features/meeting/domain/entities/participant.dart';
import 'package:waterbus/features/meeting/domain/entities/status_enum.dart';
import 'package:waterbus/features/meeting/domain/usecases/create_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/get_call_settings.dart';
import 'package:waterbus/features/meeting/domain/usecases/get_info_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/get_participant.dart';
import 'package:waterbus/features/meeting/domain/usecases/join_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/leave_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/save_call_settings.dart';
import 'package:waterbus/features/meeting/domain/usecases/update_meeting.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting_list/bloc/meeting_list_bloc.dart';

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
  final GetCallSettings _getCallSettings;
  final SaveCallSettings _saveCallSettings;
  // ignore: unused_field
  final WaterbusSdk _waterbusSdk = WaterbusSdk.instance;

  // MARK: private
  Meeting? _currentMeeting;
  Participant? _mParticipant;
  CallSetting _callSetting = CallSetting();

  MeetingBloc(
    this._createMeeting,
    this._joinMeeting,
    this._updateMeeting,
    this._getInfoMeeting,
    this._leaveMeeting,
    this._getParticipant,
    this._getCallSettings,
    this._saveCallSettings,
  ) : super(const MeetingInitial()) {
    _getCallSettings.call(null).then(
          (settings) => settings.fold((l) => null, (r) {
            _callSetting = r;
            _waterbusSdk.changeCallSetting(r);
            _waterbusSdk.onEventChangedRegister(_onEventChanged);
          }),
        );

    on<MeetingEvent>(
      transformer: sequential(),
      (event, emit) async {
        if (event is CreateMeetingEvent) {
          final Meeting? meetingCreated = await _handleCreateMeeting(event);

          if (meetingCreated != null) {
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
          // Will be take the meeting object in recent joined
          _currentMeeting = event.meeting;

          final int indexOfParticipant =
              _currentMeeting!.participants.indexWhere(
            (participant) =>
                participant.user.id == AppBloc.userBloc.user?.id &&
                participant.role == MeetingRole.host,
          );

          final bool isHost = indexOfParticipant != -1;

          // Will join directly if the participant is the host of room
          if (isHost) {
            if (_currentMeeting!.participants[indexOfParticipant].isMe) {
              _mParticipant = _currentMeeting!.participants[indexOfParticipant];
            }

            displayLoadingLayer();

            add(
              const JoinMeetingWithPasswordEvent(
                password: '',
                isHost: true,
              ),
            );
            return;
          }

          emit(_preJoinMeeting);
          AppNavigator.push(Routes.meetingRoute);
        }

        if (event is JoinMeetingWithPasswordEvent) {
          if (_currentMeeting == null) return;

          final bool isJoinSucceed = await _handleJoinWithPassword(event);

          if (isJoinSucceed) {
            await _initialWebRTCManager(
              roomCode: _currentMeeting!.code.toString(),
              participantId: _mParticipant!.id,
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
          final Meeting? meeting = await _handleGetInfoMeeting(event);

          if (meeting != null) {
            await _displayDialogJoinMeeting(meeting);

            emit(_preJoinMeeting);
          }
        }

        if (event is LeaveMeetingEvent) {
          if (state is PreJoinMeeting) {
            await _dispose();
          } else {
            await _handleLeaveMeeting(event);
          }
          emit(_meetingInitial);
        }

        if (event is DisplayDialogMeetingEvent) {
          await _displayDialogJoinMeeting(event.meeting);

          emit(_preJoinMeeting);
        }

        if (event is StartSharingScreenEvent) {
          await _waterbusSdk.startScreenSharing();
        }

        if (event is StopSharingScreenEvent) {
          await _waterbusSdk.stopScreenSharing();
        }

        if (event is ToggleVideoEvent) {
          await _waterbusSdk.toggleVideo();

          if (state is JoinedMeeting) {
            emit(_joinedMeeting);
          } else if (state is PreJoinMeeting) {
            emit(_preJoinMeeting);
          }
        }

        if (event is ToggleAudioEvent) {
          await _waterbusSdk.toggleAudio();

          if (state is JoinedMeeting) {
            emit(_joinedMeeting);
          } else if (state is PreJoinMeeting) {
            emit(_preJoinMeeting);
          }
        }

        if (event is SaveCallSettingsEvent) {
          _saveCallSettings.call(event.setting);

          _callSetting = event.setting;

          _waterbusSdk.changeCallSetting(_callSetting);

          if (state is JoinedMeeting) {
            // Hot update settings
            return;
          }

          emit(_meetingInitial);
        }

        if (event is RefreshDisplayMeetingEvent) {
          if (state is MeetingInitial) return;

          if (state is PreJoinMeeting) {
            emit(_preJoinMeeting);
          } else {
            emit(_joinedMeeting);
          }
        }

        if (event is DisposeMeetingEvent) {
          await _dispose();
          emit(_meetingInitial);
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
      },
    );
  }

  // MARK: state
  MeetingInitial get _meetingInitial => MeetingInitial(
        callSetting: _callSetting,
      );

  JoinedMeeting get _joinedMeeting => JoinedMeeting(
        meeting: _currentMeeting,
        participant: _mParticipant,
        callState: _waterbusSdk.callState,
        callSetting: _callSetting,
      );

  PreJoinMeeting get _preJoinMeeting => PreJoinMeeting(
        meeting: _currentMeeting,
        participant: _mParticipant,
        callState: _waterbusSdk.callState,
        callSetting: _callSetting,
      );

  // MARK: Private
  Future<Meeting?> _handleCreateMeeting(CreateMeetingEvent event) async {
    final Either<Failure, Meeting> meeting = await _createMeeting.call(
      CreateMeetingParams(
        meeting: Meeting(title: event.roomName),
        password: event.password,
      ),
    );

    AppNavigator.pop();

    return meeting.fold((l) => null, (r) async {
      _mParticipant = r.participants.first;

      await _initialWebRTCManager(
        roomCode: r.code.toString(),
        participantId: _mParticipant!.id,
      );

      AppNavigator.replaceWith(Routes.meetingRoute);
      AppBloc.meetingListBloc.add(InsertRecentJoinEvent(meeting: r));
      _currentMeeting = r;

      return r;
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

      AppBloc.meetingListBloc.add(
        InsertRecentJoinEvent(meeting: r),
      );

      final int indexOfMyParticipant = r.participants.lastIndexWhere(
        (participant) => participant.isMe,
      );

      if (indexOfMyParticipant != -1) {
        _mParticipant = r.participants[indexOfMyParticipant];
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
    if (_currentMeeting == null || _mParticipant == null) return;

    final Either<Failure, Meeting> isLeaveSucceed = await _leaveMeeting.call(
      LeaveMeetingParams(
        code: _currentMeeting!.code,
        participantId: _mParticipant!.id,
      ),
    );

    AppNavigator.pop();

    isLeaveSucceed.fold((l) => null, (r) {
      _currentMeeting = null;
      _mParticipant = null;

      if (!event.isReleasedWaterbusSdk) {
        _waterbusSdk.leaveRoom();
      }

      AppNavigator.pop();
    });
  }

  Future<void> _handleNewParticipant(NewParticipantEvent event) async {
    if (_currentMeeting == null) return;

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
    await _waterbusSdk.joinRoom(
      roomId: roomCode,
      participantId: participantId,
    );
  }

  Future<void> _displayDialogJoinMeeting(Meeting meeting) async {
    await _waterbusSdk.prepareMedia();

    bool isDismissWithoutJoin = true;

    showDialogWaterbus(
      alignment: Alignment.bottomCenter,
      paddingBottom: 56.sp,
      child: DialogPrepareMeeting(
        meeting: meeting,
        handleJoinMeeting: () {
          isDismissWithoutJoin = false;

          AppNavigator.popUntil(Routes.rootRoute);
          add(JoinMeetingEvent(meeting: meeting));
        },
      ),
    ).then((value) {
      if (isDismissWithoutJoin) {
        add(DisposeMeetingEvent());
      }
    });
  }

  void _onEventChanged(CallbackPayload event) {
    switch (event.event) {
      case CallbackEvents.shouldBeUpdateState:
        add(RefreshDisplayMeetingEvent());
        break;
      case CallbackEvents.newParticipant:
        final String? participantId = event.participantId;
        if (participantId == null) return;

        add(NewParticipantEvent(participantId: participantId));
        break;
      case CallbackEvents.participantHasLeft:
        final String? participantId = event.participantId;
        if (participantId == null) return;

        add(ParticipantHasLeftEvent(participantId: participantId));
        break;
      case CallbackEvents.meetingEnded:
        if (state is JoinedMeeting) {
          displayLoadingLayer();
          add(const LeaveMeetingEvent(isReleasedWaterbusSdk: true));
        } else if (state is PreJoinMeeting) {
          add(DisposeMeetingEvent());
        }

        break;
      default:
        break;
    }
  }

  Future<void> _dispose() async {
    await _waterbusSdk.leaveRoom();
    _currentMeeting = null;
    _mParticipant = null;
  }

  // MARK: export
  CallSetting get callSetting => _callSetting;
}
