// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

// Project imports:
import 'package:waterbus/services/webrtc/models/call_state.dart';

void main() {
  group('CallState', () {
    test('copyWith() should create a copy with updated values', () {
      // Arrange
      final initialCallState = CallState(
        localRenderer: null,
        remoteRenderers: {},
        remoteMicState: {},
        remoteCameraState: {},
        localMicState: true,
        localCameraState: true,
      );

      // Act
      final updatedCallState = initialCallState.copyWith(
        localMicState: false,
        localCameraState: false,
        remoteMicState: {'1': true},
        remoteCameraState: {'1': true},
        remoteRenderers: {'1': RTCVideoRenderer()},
        localRenderer: RTCVideoRenderer(),
      );

      final callStateClone = initialCallState.copyWith();

      // Assert
      expect(initialCallState.toString(), callStateClone.toString());
      expect(updatedCallState.localMicState, false);
      expect(updatedCallState.localCameraState, false);
      expect(updatedCallState.remoteMicState['1'], true);
      expect(updatedCallState.remoteCameraState['1'], true);
      expect(updatedCallState.remoteRenderers['1'], isA<RTCVideoRenderer>());
      expect(updatedCallState.localRenderer, isA<RTCVideoRenderer>());
    });

    test('toString() should return a string with correct format', () {
      // Arrange
      final callState = CallState(
        localRenderer: RTCVideoRenderer(),
        remoteRenderers: {},
        remoteMicState: {},
        remoteCameraState: {},
        localMicState: true,
        localCameraState: true,
      );

      // Act
      final result = callState.toString();

      // Assert
      expect(
          result,
          'MeetingState(localRenderer: ${callState.localRenderer}, '
          'remoteRenderers: ${callState.remoteRenderers}, '
          'remoteMicState: ${callState.remoteMicState}, '
          'remoteCameraState: ${callState.remoteCameraState}, '
          'localMicState: ${callState.localMicState}, '
          'localCameraState: ${callState.localCameraState})');
    });
  });
}
