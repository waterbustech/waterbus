// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';
import 'package:sdp_transform/sdp_transform.dart';

// Project imports:
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/types/extensions/duration_x.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/domain/entities/call_state.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting_bloc.dart';
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
  Future<void> addBroadcastIceCandidate(RTCIceCandidate candidate);
  Future<void> addReceiverIceCandidate(
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
  final Map<String, List<RTCIceCandidate>> _receiverCandidates = {};
  final Map<String, List<RTCIceCandidate>> _queueServerCandidates = {};
  final Map<String, bool> _flagsServerReceiveCandidates = {};
  final Map<String, bool> _flagsReceiveSdp = {};
  final List<RTCIceCandidate> _candidates = [];
  bool _flagReceiveSdp = false;
  bool _flagRenegotiationNeeded = false;

  bool _myMicEnabled = true;
  bool _myCamEnabled = true;

  // MARK: export
  @override
  CallState callState() {
    return CallState(
      localRenderer: _localRenderer,
      remoteRenderers: _remoteRenderers,
      remoteCameraState: {},
      remoteMicState: {},
      localCameraState: _myCamEnabled,
      localMicState: _myMicEnabled,
    );
  }

  @override
  Future<void> dispose() async {
    if (_roomId == null) return;

    _wsConnections.leaveRoom(_roomId!);

    _flagsReceiveSdp.clear();
    _receiverCandidates.clear();
    _candidates.clear();
    _flagsServerReceiveCandidates.clear();
    _queueServerCandidates.clear();
    _flagReceiveSdp = false;
    _flagRenegotiationNeeded = false;

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
        'sampleRate': '48000',
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
          'minHeight': '360',
          'minWidth': '480',
          'minFrameRate': '15',
          'frameRate': '15',
          'height': '360',
          'width': '480',
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

    await _toggleSpeakerPhone();

    _pcStreamLocalMedia = await _createPeerConnection();

    _localStream?.getTracks().forEach((track) {
      _pcStreamLocalMedia?.addTrack(track, _localStream!);
    });

    _pcStreamLocalMedia?.onIceCandidate = (candidate) {
      if (_flagReceiveSdp) {
        _wsConnections.sendBroadcastCandidate(candidate);
      } else {
        _candidates.add(candidate);
      }
    };

    _pcStreamLocalMedia?.onRenegotiationNeeded = () async {
      if (_flagRenegotiationNeeded) return;

      _flagRenegotiationNeeded = true;

      final String sdp = await _createOffer(
        _pcStreamLocalMedia!,
        isReceive: false,
      );
      final RTCSessionDescription description = RTCSessionDescription(
        sdp,
        'offer',
      );
      await _pcStreamLocalMedia?.setLocalDescription(description);
      _wsConnections.establishBroadcast(
        sdp: sdp,
        roomId: _roomId!,
        participantId: participantId.toString(),
      );
    };
  }

  @override
  Future<void> establishReceiverStream(List<String> targetIds) async {
    final List<Future<void>> makeConnections = targetIds
        .map(
          (targetId) => _makeConnectionReceive(
            targetId,
          ),
        )
        .toList();
    await Future.wait(makeConnections);
  }

  @override
  Future<void> newParticipant(String targetId) async {
    await Future.delayed(1.seconds);
    await _makeConnectionReceive(targetId);
  }

  @override
  Future<void> participantHasLeft(String targetId) async {
    await _remoteRenderers[targetId]?.dispose();
    await _pcReceiveMedia[targetId]?.close();
    _remoteRenderers.remove(targetId);
    _pcReceiveMedia.remove(targetId);
    _flagsReceiveSdp.remove(targetId);
    _flagsServerReceiveCandidates.remove(targetId);
    _queueServerCandidates.remove(targetId);
  }

  @override
  Future<void> setBroadcastRemoteSdp(String sdp) async {
    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      'answer',
    );

    await _pcStreamLocalMedia?.setRemoteDescription(description);

    for (final candidate in _candidates) {
      _wsConnections.sendBroadcastCandidate(candidate);
    }

    _candidates.clear();
    _flagReceiveSdp = true;
  }

  @override
  Future<void> setReceiverRemoteSdp(String targetId, String sdp) async {
    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      'answer',
    );

    final rtcPeerConnection = _pcReceiveMedia[targetId];
    if (rtcPeerConnection != null) {
      try {
        await rtcPeerConnection.setRemoteDescription(description);
      } catch (e) {
        debugPrint('Error setting remote description: $e');
      }

      // MARK: send local candidate queue to server
      for (final candidate in _receiverCandidates[targetId] ?? []) {
        _wsConnections.sendReceiverCandidate(
          candidate: candidate,
          targetId: targetId,
        );
      }

      _receiverCandidates.remove(targetId);
      _flagsReceiveSdp[targetId] = true;

      // MARK: process remote candidate queue
      _flagsServerReceiveCandidates[targetId] = true;
      for (final candidate in _queueServerCandidates[targetId] ?? []) {
        addReceiverIceCandidate(targetId, candidate);
      }
      _queueServerCandidates.remove(targetId);
    } else {
      debugPrint('RTCPeerConnection not found for $targetId');
    }
  }

  @override
  Future<void> addBroadcastIceCandidate(RTCIceCandidate candidate) async {
    if (_pcStreamLocalMedia == null) return;

    await _pcStreamLocalMedia?.addCandidate(candidate);
  }

  @override
  Future<void> addReceiverIceCandidate(
    String targetId,
    RTCIceCandidate candidate,
  ) async {
    if (_flagsServerReceiveCandidates[targetId] ?? false) {
      await _pcReceiveMedia[targetId]?.addCandidate(candidate);
    } else {
      final List<RTCIceCandidate> candidates =
          _queueServerCandidates[targetId] ?? [];

      candidates.add(candidate);

      _queueServerCandidates[targetId] = candidates;
    }
  }

  @override
  Future<void> toggleCam() async {
    final tracks = _localStream?.getVideoTracks() ?? [];

    if (_myCamEnabled) {
      for (final track in tracks) {
        track.enabled = false;
      }
    } else {
      for (final track in tracks) {
        track.enabled = true;
      }
    }
    _myCamEnabled = !_myCamEnabled;
  }

  @override
  Future<void> toggleMic() async {
    final tracks = _localStream?.getAudioTracks() ?? [];

    if (_myMicEnabled) {
      for (final track in tracks) {
        track.enabled = false;
      }
    } else {
      for (final track in tracks) {
        track.enabled = true;
      }
    }
    _myMicEnabled = !_myMicEnabled;
  }

  // MARK: Private methods
  Future<RTCPeerConnection> _createPeerConnection() async {
    final RTCPeerConnection pc = await createPeerConnection(
      configurationWebRTC,
    );

    return pc;
  }

  Future<String> _createOffer(
    RTCPeerConnection peerConnection, {
    required bool isReceive,
  }) async {
    final RTCSessionDescription description = await peerConnection.createOffer({
      'mandatory': {
        'OfferToReceiveAudio': isReceive,
        'OfferToReceiveVideo': isReceive,
      },
      'optional': [],
    });
    final session = parse(description.sdp.toString());
    final String sdp = write(session, null);

    return sdp;
  }

  Future<void> _makeConnectionReceive(String targetId) async {
    _remoteRenderers[targetId] = RTCVideoRenderer();
    _flagsReceiveSdp[targetId] = false;

    final RTCPeerConnection rtcPeerConnection = await _createPeerConnection();

    rtcPeerConnection.addTransceiver(
      kind: RTCRtpMediaType.RTCRtpMediaTypeVideo,
      init: RTCRtpTransceiverInit(
        direction: TransceiverDirection.RecvOnly,
      ),
    );

    rtcPeerConnection.addTransceiver(
      kind: RTCRtpMediaType.RTCRtpMediaTypeAudio,
      init: RTCRtpTransceiverInit(
        direction: TransceiverDirection.RecvOnly,
      ),
    );

    rtcPeerConnection.onAddStream = (stream) async {
      if (_remoteRenderers[targetId] == null) return;

      await _remoteRenderers[targetId]?.initialize();
      _remoteRenderers[targetId]?.srcObject = stream;

      AppBloc.meetingBloc.add(UpdateNewMeetingEvent());
    };

    rtcPeerConnection.onIceCandidate = (candidate) {
      if (!_flagsReceiveSdp[targetId]!) {
        final List<RTCIceCandidate> candidates =
            _receiverCandidates[targetId] ?? [];

        candidates.add(candidate);

        _receiverCandidates[targetId] = candidates;
      } else {
        _wsConnections.sendReceiverCandidate(
          candidate: candidate,
          targetId: targetId,
        );
      }
    };

    rtcPeerConnection.onRenegotiationNeeded = () async {
      final String sdp = await _createOffer(
        rtcPeerConnection,
        isReceive: true,
      );

      final RTCSessionDescription description = RTCSessionDescription(
        sdp,
        'offer',
      );
      await rtcPeerConnection.setLocalDescription(description);
      _wsConnections.establishReceiver(
        roomId: _roomId!,
        targetId: targetId,
        sdp: sdp,
      );
    };

    _pcReceiveMedia[targetId] = rtcPeerConnection;
  }

  Future<void> _toggleSpeakerPhone() async {
    Helper.setSpeakerphoneOn(true);
  }
}
