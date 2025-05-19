part of 'room_bloc.dart';

abstract class RoomState extends Equatable {
  const RoomState({
    this.isSubtitleEnabled = false,
    this.isRecording = false,
    this.subtitleStream,
    this.room,
    this.participant,
    this.callState,
    this.mediaConfig,
  });

  final bool isSubtitleEnabled;
  final Stream<String>? subtitleStream;
  final Room? room;
  final Participant? participant;
  final CallState? callState;
  final MediaConfig? mediaConfig;
  final bool isRecording;

  @override
  List<Object?> get props => [
        isSubtitleEnabled,
        subtitleStream,
        room,
        participant,
        callState,
        mediaConfig,
        identityHashCode(this),
      ];
}

class RoomInitial extends RoomState {
  const RoomInitial({super.mediaConfig});
}

class RoomPreJoin extends RoomState {
  const RoomPreJoin({
    required super.room,
    required super.participant,
    required super.callState,
    required super.mediaConfig,
  });
}

class RoomJoined extends RoomState {
  const RoomJoined({
    required super.isSubtitleEnabled,
    required super.subtitleStream,
    required super.room,
    required super.participant,
    required super.callState,
    required super.mediaConfig,
    required super.isRecording,
  });
}
