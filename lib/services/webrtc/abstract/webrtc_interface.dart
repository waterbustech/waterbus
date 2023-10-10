// Package imports:
import 'package:flutter_webrtc/flutter_webrtc.dart';

// Project imports:
import 'package:waterbus/services/webrtc/models/call_state.dart';

abstract class WaterbusWebRTCManager {
  Future<void> joinRoom({required String roomId, required int participantId});
  Future<void> subscribe(List<String> targetIds);
  Future<void> setPublisherRemoteSdp(String sdp);
  Future<void> setSubscriberRemoteSdp(String targetId, String sdp);
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
  Stream<CallState> get notifyChanged;
}
