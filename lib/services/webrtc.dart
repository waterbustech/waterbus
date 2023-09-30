// Package imports:
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';
import 'package:sdp_transform/sdp_transform.dart';

// Project imports:
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/features/meeting/domain/entities/call_state.dart';
import 'package:waterbus/services/socket.dart';

abstract class WaterbusWebRTCManager {
  Future<void> startBroadcastLocalMedia(String roomId);
  Future<void> establishReceiverStream();
  Future<MediaStream> getUserMedia();
  Future<MediaStream> getDisplayMedia();
  Future<void> setBroadcastRemoteSdp();
  Future<void> setReceiverRemoteSdp(String targetId);
  Future<void> dispose();
}

@LazySingleton(as: WaterbusWebRTCManager)
class WaterbusWebRTCManagerIpml extends WaterbusWebRTCManager {
  final SocketConnection _wsConnections;
  WaterbusWebRTCManagerIpml(this._wsConnections);

  String? _roomId;
  RTCPeerConnection? _pcStreamLocalMedia;
  RTCVideoRenderer? _localRenderer;
  MediaStream? _localStream;
  final Map<String, RTCPeerConnection> _pcReceiveMedia = {};
  final Map<String, RTCVideoRenderer> _remoteRenderers = {};

  // MARK: export
  CallState get callState => CallState(
        localRenderer: _localRenderer,
        remoteRenderers: _remoteRenderers,
        remoteCameraState: {},
        remoteMicState: {},
        localCameraState: true,
        localMicState: true,
      );

  @override
  Future<void> dispose() async {
    for (final pc in _pcReceiveMedia.values) {
      await pc.close();
    }

    _pcReceiveMedia.clear();
    _remoteRenderers.clear();

    await _localStream?.dispose();
    await _pcStreamLocalMedia?.close();
    _pcStreamLocalMedia = null;
    _localRenderer = null;
    _localStream = null;
  }

  @override
  Future<MediaStream> getDisplayMedia() {
    throw UnimplementedError();
  }

  @override
  Future<MediaStream> getUserMedia() async {
    const Map<String, dynamic> mediaConstraints = {
      'audio': {
        'sampleRate': '96000',
        'sampleSize': '16',
        'channelCount': '1',
        'mandatory': {
          'googEchoCancellation': 'true',
          'googEchoCancellation2': 'true',
          'googNoiseSuppression': 'true',
          'googNoiseSuppression2': 'true',
          'googAutoGainControl': 'true',
          'googAutoGainControl2': 'true',
          'googDAEchoCancellation': 'true',
          'googTypingNoiseDetection': 'true',
          'googAudioMirroring': 'false',
          'googHighpassFilter': 'true',
        },
        'optional': [],
      },
      'video': {
        'mandatory': {
          'minHeight': '720',
          'minWidth': '1280',
          'minFrameRate': '24',
          'frameRate': '24',
          'height': '720',
          'width': '1280',
        },
        'facingMode': 'user',
        'optional': [],
      },
    };

    final MediaStream stream = await navigator.mediaDevices.getUserMedia(
      mediaConstraints,
    );

    return stream;
  }

  @override
  Future<void> establishReceiverStream() {
    throw UnimplementedError();
  }

  @override
  Future<void> startBroadcastLocalMedia(String roomId) async {
    if (_pcStreamLocalMedia != null) return;

    _roomId = roomId;

    _localStream = await getUserMedia();
    _pcStreamLocalMedia = await _createPeerConnection();

    _localStream!.getTracks().forEach((track) {
      _pcStreamLocalMedia?.addTrack(track, _localStream!);
    });

    final String sdp = await _createOffer(_pcStreamLocalMedia!);
    _wsConnections.establishBroadcast(sdp: sdp, roomId: _roomId!);
  }

  @override
  Future<void> setBroadcastRemoteSdp() {
    throw UnimplementedError();
  }

  @override
  Future<void> setReceiverRemoteSdp(String targetId) {
    throw UnimplementedError();
  }

  // MARK: Private methods
  Future<RTCPeerConnection> _createPeerConnection() async {
    final RTCPeerConnection pc = await createPeerConnection(
      configurationWebRTC,
      offerSdpConstraints,
    );

    return pc;
  }

  Future<String> _createOffer(
    RTCPeerConnection peerConnection,
  ) async {
    final RTCSessionDescription description =
        await peerConnection.createOffer();
    final session = parse(description.sdp.toString());
    final String sdp = write(session, null);

    peerConnection.setLocalDescription(description);

    return sdp;
  }
}
