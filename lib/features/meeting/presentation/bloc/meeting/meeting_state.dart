part of 'meeting_bloc.dart';

abstract class MeetingState extends Equatable {
  const MeetingState({
    this.isSubtitleEnabled = false,
    this.isRecording = false,
    this.subtitleStream,
    this.meeting,
    this.participant,
    this.callState,
    this.callSetting,
  });

  final bool isSubtitleEnabled;
  final Stream<String>? subtitleStream;
  final Meeting? meeting;
  final Participant? participant;
  final CallState? callState;
  final CallSetting? callSetting;
  final bool isRecording;

  @override
  List<Object?> get props => [
        isSubtitleEnabled,
        subtitleStream,
        meeting,
        participant,
        callState,
        callSetting,
        identityHashCode(this),
      ];
}

class MeetingInitial extends MeetingState {
  const MeetingInitial({super.callSetting});
}

class PreJoinMeeting extends MeetingState {
  const PreJoinMeeting({
    required super.meeting,
    required super.participant,
    required super.callState,
    required super.callSetting,
  });
}

class JoinedMeeting extends MeetingState {
  const JoinedMeeting({
    required super.isSubtitleEnabled,
    required super.subtitleStream,
    required super.meeting,
    required super.participant,
    required super.callState,
    required super.callSetting,
    required super.isRecording,
  });
}
