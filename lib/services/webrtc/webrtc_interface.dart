// Package imports:
import 'package:flutter_webrtc/flutter_webrtc.dart';

// Project imports:
import 'package:waterbus/features/meeting/domain/entities/call_state.dart';

abstract class WaterbusWebRTCManager {
  Future<void> startBroadcastLocalMedia({
    required String roomId,
    required int participantId,
  });
  Future<void> establishReceiverStream(List<String> targetIds);
  Future<void> setBroadcastRemoteSdp(String sdp);
  Future<void> setReceiverRemoteSdp(String targetId, String sdp);
  Future<void> addPublisherCandidate(RTCIceCandidate candidate);
  Future<void> addSubscriberCandidate(
    String targetId,
    RTCIceCandidate candidate,
  );
  Future<void> newParticipant(String targetId);
  Future<void> participantHasLeft(String targetId);
  Future<void> dispose();

  // MARK: control
  Future<void> toggleMic();
  Future<void> toggleCam();

  CallState callState();
}
