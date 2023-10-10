// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class ParticipantSFU extends Equatable {
  final String participantId;
  final RTCPeerConnection? peerConnection;
  RTCVideoRenderer? renderer;
  bool isMicEnabled;
  bool isCamEnabled;
  bool isSharingScreen;
  bool hasFirstFrameRendered;
  final Function() onChanged;
  ParticipantSFU({
    required this.participantId,
    this.isMicEnabled = true,
    this.isCamEnabled = true,
    this.isSharingScreen = false,
    this.hasFirstFrameRendered = false,
    required this.peerConnection,
    this.renderer,
    required this.onChanged,
  }) {
    _initialRenderer();
  }

  ParticipantSFU copyWith({
    String? participantId,
    bool? isMicEnabled,
    bool? isCamEnabled,
    bool? isSharingScreen,
    RTCPeerConnection? peerConnection,
    RTCVideoRenderer? renderer,
  }) {
    return ParticipantSFU(
      participantId: participantId ?? this.participantId,
      isMicEnabled: isMicEnabled ?? this.isMicEnabled,
      isCamEnabled: isCamEnabled ?? this.isCamEnabled,
      isSharingScreen: isSharingScreen ?? this.isSharingScreen,
      peerConnection: peerConnection ?? this.peerConnection,
      renderer: renderer ?? this.renderer,
      onChanged: onChanged,
    );
  }

  @override
  String toString() {
    return 'ParticipantSFU(participantId: $participantId, isMicEnabled: $isMicEnabled, isCamEnabled: $isCamEnabled, isSharingScreen: $isSharingScreen, peerConnection: $peerConnection, renderer: $renderer)';
  }

  @override
  bool operator ==(covariant ParticipantSFU other) {
    if (identical(this, other)) return true;

    return other.participantId == participantId &&
        other.isMicEnabled == isMicEnabled &&
        other.isCamEnabled == isCamEnabled &&
        other.isSharingScreen == isSharingScreen &&
        other.peerConnection == peerConnection &&
        other.hasFirstFrameRendered == hasFirstFrameRendered &&
        other.renderer == renderer;
  }

  @override
  int get hashCode {
    return participantId.hashCode ^
        isMicEnabled.hashCode ^
        isCamEnabled.hashCode ^
        isSharingScreen.hashCode ^
        hasFirstFrameRendered.hashCode ^
        peerConnection.hashCode ^
        renderer.hashCode;
  }

  @override
  List<Object> get props {
    return [
      participantId,
      isMicEnabled,
      isCamEnabled,
      isSharingScreen,
      hasFirstFrameRendered,
      onChanged,
    ];
  }
}

extension ParticipantSFUX on ParticipantSFU {
  Future<void> dispose() async {
    renderer?.dispose();
    peerConnection?.close();
  }

  Future<void> addCandidate(RTCIceCandidate candidate) async {
    await peerConnection?.addCandidate(candidate);
  }

  Future<void> setRemoteDescription(RTCSessionDescription description) async {
    await peerConnection?.setRemoteDescription(description);
  }

  // ignore: use_setters_to_change_properties
  void setSrcObject(MediaStream stream) {
    renderer?.srcObject = stream;
  }

  Future<void> _initialRenderer() async {
    if (renderer != null) return;

    renderer = RTCVideoRenderer();
    await renderer?.initialize();

    renderer?.onFirstFrameRendered = () {
      hasFirstFrameRendered = true;

      onChanged.call();
    };
  }
}
