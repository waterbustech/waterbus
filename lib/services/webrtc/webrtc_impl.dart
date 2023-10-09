// Package imports:
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';
import 'package:sdp_transform/sdp_transform.dart';

// Project imports:
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';
import 'package:waterbus/services/socket.dart';
import 'package:waterbus/services/webrtc/abstract/webrtc_interface.dart';
import 'package:waterbus/services/webrtc/models/call_state.dart';

@LazySingleton(as: WaterbusWebRTCManager)
class WaterbusWebRTCManagerIpml extends WaterbusWebRTCManager {
  final SocketConnection _wsConnections;
  WaterbusWebRTCManagerIpml(this._wsConnections);

  String? _roomId;
  RTCPeerConnection? _publisherPeer;
  RTCVideoRenderer? _localRenderer;
  MediaStream? _localStream;
  final Map<String, RTCPeerConnection> _subscriberPeers = {};
  final Map<String, RTCVideoRenderer> _subscriberRenderers = {};
  final Map<String, List<RTCIceCandidate>> _queueRemoteSubscriberCandidates =
      {};
  final List<RTCIceCandidate> _queuePublisherCandidates = [];
  bool _flagPublisherCanAddCandidate = false;

  bool _myMicEnabled = true;
  bool _myCamEnabled = true;

  @override
  Future<void> startBroadcastLocalMedia({
    required String roomId,
    required int participantId,
  }) async {
    if (_publisherPeer != null) return;

    _roomId = roomId;

    _localStream = await _getUserMedia();

    await _toggleSpeakerPhone();

    _publisherPeer = await _createPeerConnection(offerPublisherSdpConstraints);

    _publisherPeer?.onIceCandidate = (candidate) {
      if (_flagPublisherCanAddCandidate) {
        _wsConnections.sendBroadcastCandidate(candidate);
      } else {
        _queuePublisherCandidates.add(candidate);
      }
    };

    _localStream?.getTracks().forEach((track) {
      _publisherPeer?.addTrack(track, _localStream!);
    });

    _publisherPeer?.onRenegotiationNeeded = () async {
      if ((await _publisherPeer?.getRemoteDescription()) != null) return;

      final String sdp = await _createOffer(_publisherPeer!);

      // sdp = WebRTCUtils.enableAudioDTX(sdp: sdp);

      final RTCSessionDescription description = RTCSessionDescription(
        sdp,
        'offer',
      );

      await _publisherPeer?.setLocalDescription(description);

      _wsConnections.establishBroadcast(
        sdp: sdp,
        roomId: _roomId!,
        participantId: participantId.toString(),
      );
    };
  }

  @override
  Future<void> establishReceiverStream(List<String> targetIds) async {
    for (final targetId in targetIds) {
      _makeConnectionReceive(targetId);
    }
  }

  @override
  Future<void> newParticipant(String targetId) async {
    await _makeConnectionReceive(targetId);
  }

  @override
  Future<void> participantHasLeft(String targetId) async {
    await _subscriberRenderers[targetId]?.dispose();
    await _subscriberPeers[targetId]?.close();
    _subscriberRenderers.remove(targetId);
    _subscriberPeers.remove(targetId);
    _queueRemoteSubscriberCandidates.remove(targetId);
  }

  @override
  Future<void> setBroadcastRemoteSdp(String sdp) async {
    if ((await _publisherPeer?.getRemoteDescription()) != null) return;

    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      'answer',
    );

    await _publisherPeer?.setRemoteDescription(description);

    for (final candidate in _queuePublisherCandidates) {
      _wsConnections.sendBroadcastCandidate(candidate);
    }

    _queuePublisherCandidates.clear();
    _flagPublisherCanAddCandidate = true;
  }

  @override
  Future<void> setReceiverRemoteSdp(String targetId, String sdp) async {
    if (_subscriberPeers[targetId] != null) return;

    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      'offer',
    );

    await _answerSubscriber(targetId, description);
  }

  @override
  Future<void> addPublisherCandidate(RTCIceCandidate candidate) async {
    if (_publisherPeer == null) return;

    await _publisherPeer?.addCandidate(candidate);
  }

  @override
  Future<void> addSubscriberCandidate(
    String targetId,
    RTCIceCandidate candidate,
  ) async {
    if (_subscriberPeers[targetId] != null) {
      await _subscriberPeers[targetId]?.addCandidate(candidate);
    } else {
      final List<RTCIceCandidate> candidates =
          _queueRemoteSubscriberCandidates[targetId] ?? [];

      candidates.add(candidate);

      _queueRemoteSubscriberCandidates[targetId] = candidates;
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

  @override
  Future<void> dispose() async {
    if (_roomId == null) return;

    _wsConnections.leaveRoom(_roomId!);

    _queuePublisherCandidates.clear();
    _queueRemoteSubscriberCandidates.clear();
    _flagPublisherCanAddCandidate = false;

    for (final pc in _subscriberPeers.values) {
      await pc.close();
    }

    _subscriberPeers.clear();
    _subscriberRenderers.clear();

    await _localStream?.dispose();
    await _publisherPeer?.close();
    _publisherPeer = null;
    _localRenderer = null;
    _localStream = null;
  }

  @override
  CallState callState() {
    return CallState(
      localRenderer: _localRenderer,
      remoteRenderers: _subscriberRenderers,
      remoteCameraState: {},
      remoteMicState: {},
      localCameraState: _myCamEnabled,
      localMicState: _myMicEnabled,
    );
  }

  // MARK: Private methods
  // Future<MediaStream> _getDisplayMedia() {
  //   throw UnimplementedError();
  // }

  Future<MediaStream> _getUserMedia() async {
    const Map<String, dynamic> mediaConstraints = defaultMediaConstraints;

    final MediaStream stream = await navigator.mediaDevices.getUserMedia(
      mediaConstraints,
    );

    _localRenderer = RTCVideoRenderer();
    await _localRenderer?.initialize();
    _localRenderer?.srcObject = stream;

    return stream;
  }

  Future<RTCPeerConnection> _createPeerConnection([
    Map<String, dynamic> constraints = const {},
  ]) async {
    final RTCPeerConnection pc = await createPeerConnection(
      configurationWebRTC,
      constraints,
    );

    return pc;
  }

  Future<String> _createOffer(RTCPeerConnection peerConnection) async {
    final RTCSessionDescription description =
        await peerConnection.createOffer();
    final session = parse(description.sdp.toString());
    final String sdp = write(session, null);

    return sdp;
  }

  Future<String> _createAnswer(RTCPeerConnection peerConnection) async {
    final RTCSessionDescription description =
        await peerConnection.createAnswer();
    final session = parse(description.sdp.toString());
    final String sdp = write(session, null);

    return sdp;
  }

  Future<void> _makeConnectionReceive(String targetId) async {
    _wsConnections.requestEstablishSubscriber(targetId: targetId);
  }

  Future<void> _answerSubscriber(
    String targetId,
    RTCSessionDescription remoteDescription,
  ) async {
    _subscriberRenderers[targetId] = RTCVideoRenderer();

    final RTCPeerConnection rtcPeerConnection = await _createPeerConnection(
      offerSubscriberSdpConstraints,
    );

    _subscriberPeers[targetId] = rtcPeerConnection;

    rtcPeerConnection.onAddStream = (stream) async {
      if (_subscriberRenderers[targetId] == null) return;

      await _subscriberRenderers[targetId]?.initialize();
      _subscriberRenderers[targetId]?.srcObject = stream;

      AppBloc.meetingBloc.add(UpdateNewMeetingEvent());
    };

    rtcPeerConnection.onIceCandidate = (candidate) {
      _wsConnections.sendReceiverCandidate(
        candidate: candidate,
        targetId: targetId,
      );
    };

    rtcPeerConnection.setRemoteDescription(remoteDescription);

    final String sdp = await _createAnswer(rtcPeerConnection);
    final RTCSessionDescription description =
        RTCSessionDescription(sdp, 'answer');
    await rtcPeerConnection.setLocalDescription(description);

    _wsConnections.answerEstablishSubscriber(targetId: targetId, sdp: sdp);

    // Process queue candidates from server
    final List<RTCIceCandidate> candidates =
        _queueRemoteSubscriberCandidates[targetId] ?? [];

    for (final candidate in candidates) {
      addSubscriberCandidate(targetId, candidate);
    }
  }

  Future<void> _toggleSpeakerPhone() async {
    Helper.setSpeakerphoneOn(true);
  }
}
