// Package imports:
import 'package:flutter_webrtc/flutter_webrtc.dart';

class ParticipantSFU {
  final String participantId;
  final RTCPeerConnection? peerConnection;
  RTCVideoRenderer? renderer;
  bool isMicEnabled;
  bool isCamEnabled;
  bool isSharingScreen;
  ParticipantSFU({
    required this.participantId,
    this.isMicEnabled = true,
    this.isCamEnabled = true,
    this.isSharingScreen = false,
    required this.peerConnection,
    this.renderer,
  });

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
        other.renderer == renderer;
  }

  @override
  int get hashCode {
    return participantId.hashCode ^
        isMicEnabled.hashCode ^
        isCamEnabled.hashCode ^
        isSharingScreen.hashCode ^
        peerConnection.hashCode ^
        renderer.hashCode;
  }
}
