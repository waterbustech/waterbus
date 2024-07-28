part of 'meeting_bloc.dart';

sealed class MeetingEvent extends Equatable {
  const MeetingEvent();

  @override
  List<Object> get props => [];
}

class InitializeMeetingEvent extends MeetingEvent {
  const InitializeMeetingEvent();
}

class PrepareMediaStreamEvent extends MeetingEvent {}

class CreateMeetingEvent extends MeetingEvent {
  final String roomName;
  final String password;
  const CreateMeetingEvent({required this.roomName, required this.password});
}

class UpdateMeetingEvent extends MeetingEvent {
  final String roomName;
  final String password;
  const UpdateMeetingEvent({required this.roomName, required this.password});
}

class JoinMeetingEvent extends MeetingEvent {
  final Meeting meeting;
  const JoinMeetingEvent({required this.meeting});
}

class JoinMeetingWithPasswordEvent extends MeetingEvent {
  final String password;
  final bool isMember;
  const JoinMeetingWithPasswordEvent({
    this.password = '',
    this.isMember = false,
  });
}

class GetInfoMeetingEvent extends MeetingEvent {
  final int roomCode;
  const GetInfoMeetingEvent({required this.roomCode});
}

class LeaveMeetingEvent extends MeetingEvent {
  final bool isReleasedWaterbusSdk;
  const LeaveMeetingEvent({this.isReleasedWaterbusSdk = false});
}

class DisposeMeetingEvent extends MeetingEvent {}

class DisplayDialogMeetingEvent extends MeetingEvent {
  final Meeting meeting;
  const DisplayDialogMeetingEvent({required this.meeting});
}

class NewParticipantEvent extends MeetingEvent {
  final Participant participant;
  const NewParticipantEvent({required this.participant});
}

class ParticipantHasLeftEvent extends MeetingEvent {
  final String participantId;
  const ParticipantHasLeftEvent({required this.participantId});
}

class StartSharingScreenEvent extends MeetingEvent {}

class StopSharingScreenEvent extends MeetingEvent {}

class ToggleAudioEvent extends MeetingEvent {}

class ToggleVideoEvent extends MeetingEvent {}

class SaveCallSettingsEvent extends MeetingEvent {
  final CallSetting setting;
  const SaveCallSettingsEvent({required this.setting});
}

class ApplyVirtualBackgroundEvent extends MeetingEvent {
  final String? backgroundPath;
  const ApplyVirtualBackgroundEvent(this.backgroundPath);
}

class ToggleSubtitleEvent extends MeetingEvent {
  const ToggleSubtitleEvent();
}

class RefreshDisplayMeetingEvent extends MeetingEvent {}
