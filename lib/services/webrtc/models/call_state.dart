// Package imports:
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallState {
  final RTCVideoRenderer? localRenderer;
  final Map<String, RTCVideoRenderer> remoteRenderers;
  final Map<String, bool> remoteMicState;
  final Map<String, bool> remoteCameraState;
  final bool localMicState;
  final bool localCameraState;
  CallState({
    required this.localRenderer,
    required this.remoteRenderers,
    required this.remoteMicState,
    required this.remoteCameraState,
    required this.localMicState,
    required this.localCameraState,
  });

  CallState copyWith({
    RTCVideoRenderer? localRenderer,
    Map<String, RTCVideoRenderer>? remoteRenderers,
    Map<String, bool>? remoteMicState,
    Map<String, bool>? remoteCameraState,
    bool? localMicState,
    bool? localCameraState,
  }) {
    return CallState(
      localRenderer: localRenderer ?? this.localRenderer,
      remoteRenderers: remoteRenderers ?? this.remoteRenderers,
      remoteMicState: remoteMicState ?? this.remoteMicState,
      remoteCameraState: remoteCameraState ?? this.remoteCameraState,
      localMicState: localMicState ?? this.localMicState,
      localCameraState: localCameraState ?? this.localCameraState,
    );
  }

  @override
  String toString() {
    return 'MeetingState(localRenderer: $localRenderer, remoteRenderers: $remoteRenderers, remoteMicState: $remoteMicState, remoteCameraState: $remoteCameraState, localMicState: $localMicState, localCameraState: $localCameraState)';
  }
}
