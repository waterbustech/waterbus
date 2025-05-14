part of 'meeting_bloc.dart';

abstract class MeetingState extends Equatable {
  const MeetingState({
    this.isSubtitleEnabled = false,
    this.isRecording = false,
    this.subtitleStream,
    this.meeting,
    this.participant,
    this.callState,
    this.mediaConfig,
  });

  final bool isSubtitleEnabled;
  final Stream<String>? subtitleStream;
  final Meeting? meeting;
  final Participant? participant;
  final CallState? callState;
  final MediaConfig? mediaConfig;
  final bool isRecording;

  @override
  List<Object?> get props => [
        isSubtitleEnabled,
        subtitleStream,
        meeting,
        participant,
        callState,
        mediaConfig,
        identityHashCode(this),
      ];
}

class MeetingInitial extends MeetingState {
  const MeetingInitial({super.mediaConfig});
}

class MeetingPreJoin extends MeetingState {
  const MeetingPreJoin({
    required super.meeting,
    required super.participant,
    required super.callState,
    required super.mediaConfig,
  });
}

class MeetingJoined extends MeetingState {
  const MeetingJoined({
    required super.isSubtitleEnabled,
    required super.subtitleStream,
    required super.meeting,
    required super.participant,
    required super.callState,
    required super.mediaConfig,
    required super.isRecording,
  });
}
