// Package imports:
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';
import 'package:sdp_transform/sdp_transform.dart';

// Project imports:
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/features/meeting/domain/entities/call_state.dart';
import 'package:waterbus/services/socket.dart';

abstract class WaterbusWebRTCManager {
  Future<void> startBroadcastLocalMedia({
    required String roomId,
    required int participantId,
  });
  Future<void> establishReceiverStream(List<String> targetIds);
  Future<MediaStream> getUserMedia();
  Future<MediaStream> getDisplayMedia();
  Future<void> setBroadcastRemoteSdp(String sdp);
  Future<void> setReceiverRemoteSdp(String targetId, String sdp);
  Future<void> newParticipant(String targetId);
  Future<void> participantHasLeft(String targetId);
  Future<void> dispose();

  CallState callState();
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
  @override
  CallState callState() {
    return CallState(
      localRenderer: _localRenderer,
      remoteRenderers: _remoteRenderers,
      remoteCameraState: {},
      remoteMicState: {},
      localCameraState: true,
      localMicState: true,
    );
  }

  @override
  Future<void> dispose() async {
    if (_roomId == null) return;

    _wsConnections.leaveRoom(_roomId!);

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

    _localRenderer = RTCVideoRenderer();
    await _localRenderer?.initialize();
    _localRenderer?.srcObject = stream;

    return stream;
  }

  @override
  Future<void> startBroadcastLocalMedia({
    required String roomId,
    required int participantId,
  }) async {
    if (_pcStreamLocalMedia != null) return;

    _roomId = roomId;

    _localStream = await getUserMedia();

    _pcStreamLocalMedia = await _createPeerConnection();

    _localStream!.getTracks().forEach((track) {
      _pcStreamLocalMedia?.addTrack(track, _localStream!);
    });

    final String sdp = await _createOffer(_pcStreamLocalMedia!);
    _wsConnections.establishBroadcast(
      sdp: sdp,
      roomId: _roomId!,
      participantId: participantId.toString(),
    );
  }

  @override
  Future<void> establishReceiverStream(List<String> targetIds) async {
    for (final targetId in targetIds) {
      await _makeConnectionReceive(targetId);
    }
  }

  @override
  Future<void> newParticipant(String targetId) async {
    await _makeConnectionReceive(targetId);
  }

  @override
  Future<void> participantHasLeft(String targetId) async {
    await _remoteRenderers[targetId]?.dispose();
    await _pcReceiveMedia[targetId]?.close();
    _remoteRenderers.remove(targetId);
    _pcReceiveMedia.remove(targetId);
  }

  @override
  Future<void> setBroadcastRemoteSdp(String sdp) async {
    await _setRemoteDescription(pc: _pcStreamLocalMedia!, sdp: sdp);
  }

  @override
  Future<void> setReceiverRemoteSdp(String targetId, String sdp) async {
    final RTCPeerConnection? pc = _pcReceiveMedia[targetId];

    if (pc == null) return;

    await _setRemoteDescription(pc: pc, sdp: sdp);
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

  Future<void> _setRemoteDescription({
    required RTCPeerConnection pc,
    required String sdp,
  }) async {
    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      'answer',
    );

    await pc.setRemoteDescription(description);
  }

  Future<void> _makeConnectionReceive(String targetId) async {
    _remoteRenderers[targetId] = RTCVideoRenderer();

    final RTCPeerConnection rtcPeerConnection = await _createPeerConnection();

    rtcPeerConnection.addTransceiver(
      kind: RTCRtpMediaType.RTCRtpMediaTypeVideo,
      init: RTCRtpTransceiverInit(
        direction: TransceiverDirection.RecvOnly,
      ),
    );

    rtcPeerConnection.onTrack = (track) {
      _remoteRenderers[targetId]?.srcObject = track.streams.first;
    };

    final String sdp = await _createOffer(rtcPeerConnection);
    _wsConnections.establishReceiver(
      roomId: _roomId!,
      targetId: targetId,
      sdp: sdp,
    );

    _pcReceiveMedia[targetId] = rtcPeerConnection;
  }
}
