// Dart imports:
import 'dart:async';

// Package imports:
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';
import 'package:sdp_transform/sdp_transform.dart';

// Project imports:
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/services/socket.dart';
import 'package:waterbus/services/webrtc/abstract/webrtc_interface.dart';
import 'package:waterbus/services/webrtc/helpers/extensions/sdp_extensions.dart';
import 'package:waterbus/services/webrtc/models/call_state.dart';
import 'package:waterbus/services/webrtc/models/description_type.dart';
import 'package:waterbus/services/webrtc/models/participant_sfu.dart';

@LazySingleton(as: WaterbusWebRTCManager)
class WaterbusWebRTCManagerIpml extends WaterbusWebRTCManager {
  final SocketConnection _wsConnections;
  WaterbusWebRTCManagerIpml(this._wsConnections);

  String? _roomId;
  MediaStream? _localStream;
  ParticipantSFU? _mParticipant;
  bool _flagPublisherCanAddCandidate = false;
  final Map<String, ParticipantSFU> _subscribers = {};
  final Map<String, List<RTCIceCandidate>> _queueRemoteSubCandidates = {};
  final List<RTCIceCandidate> _queuePublisherCandidates = [];
  // ignore: close_sinks
  final StreamController<CallState> _notifyChanged =
      StreamController<CallState>.broadcast();

  @override
  Future<void> joinRoom({
    required String roomId,
    required int participantId,
  }) async {
    if (_mParticipant?.peerConnection != null) return;

    _roomId = roomId;

    _localStream = await _getUserMedia();

    final RTCPeerConnection peerConnection = await _createPeerConnection(
      offerPublisherSdpConstraints,
    );

    _mParticipant = ParticipantSFU(
      participantId: participantId.toString(),
      peerConnection: peerConnection,
      onChanged: _notify,
    );

    _mParticipant?.setSrcObject(_localStream!);

    peerConnection.onIceCandidate = (candidate) {
      if (_flagPublisherCanAddCandidate) {
        _wsConnections.sendBroadcastCandidate(candidate);
      } else {
        _queuePublisherCandidates.add(candidate);
      }
    };

    _localStream?.getTracks().forEach((track) {
      peerConnection.addTrack(track, _localStream!);
    });

    peerConnection.onRenegotiationNeeded = () async {
      if ((await peerConnection.getRemoteDescription()) != null) return;

      String sdp = await _createOffer(peerConnection);

      sdp = sdp.enableAudioDTX();

      final RTCSessionDescription description = RTCSessionDescription(
        sdp,
        DescriptionType.offer.type,
      );

      await peerConnection.setLocalDescription(description);

      _wsConnections.establishBroadcast(
        sdp: sdp,
        roomId: _roomId!,
        participantId: participantId.toString(),
      );
    };
  }

  @override
  Future<void> subscribe(List<String> targetIds) async {
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
    await _subscribers[targetId]?.dispose();
    _subscribers.remove(targetId);
    _queueRemoteSubCandidates.remove(targetId);
  }

  @override
  Future<void> setPublisherRemoteSdp(String sdp) async {
    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      DescriptionType.answer.type,
    );

    await _mParticipant?.setRemoteDescription(description);

    for (final candidate in _queuePublisherCandidates) {
      _wsConnections.sendBroadcastCandidate(candidate);
    }

    _queuePublisherCandidates.clear();
    _flagPublisherCanAddCandidate = true;
  }

  @override
  Future<void> setSubscriberRemoteSdp(
    String targetId,
    String sdp,
    bool videoEnabled,
    bool audioEnabled,
  ) async {
    if (_subscribers[targetId] != null) return;

    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      DescriptionType.offer.type,
    );

    await _answerSubscriber(
      targetId,
      description,
      videoEnabled,
      audioEnabled,
    );
  }

  @override
  Future<void> addPublisherCandidate(RTCIceCandidate candidate) async {
    await _mParticipant?.addCandidate(candidate);
  }

  @override
  Future<void> addSubscriberCandidate(
    String targetId,
    RTCIceCandidate candidate,
  ) async {
    if (_subscribers[targetId] != null) {
      await _subscribers[targetId]?.addCandidate(candidate);
    } else {
      final List<RTCIceCandidate> candidates =
          _queueRemoteSubCandidates[targetId] ?? [];

      candidates.add(candidate);

      _queueRemoteSubCandidates[targetId] = candidates;
    }
  }

  @override
  Future<void> toggleCam() async {
    if (_mParticipant == null) return;

    final tracks = _localStream?.getVideoTracks() ?? [];

    if (_mParticipant!.isAudioEnabled) {
      for (final track in tracks) {
        track.enabled = false;
      }
    } else {
      for (final track in tracks) {
        track.enabled = true;
      }
    }

    _mParticipant!.isAudioEnabled = !_mParticipant!.isAudioEnabled;
    _notify();

    _wsConnections.setVideoEnabled(_mParticipant!.isAudioEnabled);
  }

  @override
  Future<void> toggleMic() async {
    if (_mParticipant == null) return;

    final tracks = _localStream?.getAudioTracks() ?? [];

    if (_mParticipant!.isVideoEnabled) {
      for (final track in tracks) {
        track.enabled = false;
      }
    } else {
      for (final track in tracks) {
        track.enabled = true;
      }
    }

    _mParticipant!.isVideoEnabled = !_mParticipant!.isVideoEnabled;
    _notify();

    _wsConnections.setAudioEnabled(_mParticipant!.isVideoEnabled);
  }

  @override
  void setVideoEnabled({required String targetId, required bool isEnabled}) {
    _subscribers[targetId]?.isAudioEnabled = isEnabled;
    _notify();
  }

  @override
  void setAudioEnabled({required String targetId, required bool isEnabled}) {
    _subscribers[targetId]?.isVideoEnabled = isEnabled;
    _notify();
  }

  @override
  Future<void> dispose() async {
    if (_roomId == null) return;

    _wsConnections.leaveRoom(_roomId!);

    _queuePublisherCandidates.clear();
    _queueRemoteSubCandidates.clear();
    _flagPublisherCanAddCandidate = false;

    for (final subscriber in _subscribers.values) {
      await subscriber.dispose();
    }
    _subscribers.clear();

    await _localStream?.dispose();
    await _mParticipant?.dispose();
    _mParticipant = null;
    _localStream = null;
  }

  // MARK: Private methods
  Future<MediaStream> _getUserMedia() async {
    const Map<String, dynamic> mediaConstraints = defaultMediaConstraints;

    final MediaStream stream = await navigator.mediaDevices.getUserMedia(
      mediaConstraints,
    );

    await _toggleSpeakerPhone();

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
    bool videoEnabled,
    bool audioEnabled,
  ) async {
    final RTCPeerConnection rtcPeerConnection = await _createPeerConnection(
      offerSubscriberSdpConstraints,
    );

    _subscribers[targetId] = ParticipantSFU(
      participantId: targetId,
      peerConnection: rtcPeerConnection,
      onChanged: _notify,
      isAudioEnabled: videoEnabled,
      isVideoEnabled: audioEnabled,
    );

    rtcPeerConnection.onAddStream = (stream) async {
      if (_subscribers[targetId] == null) return;

      _subscribers[targetId]?.setSrcObject(stream);
    };

    rtcPeerConnection.onIceCandidate = (candidate) {
      _wsConnections.sendReceiverCandidate(
        candidate: candidate,
        targetId: targetId,
      );
    };

    rtcPeerConnection.setRemoteDescription(remoteDescription);

    final String sdp = await _createAnswer(rtcPeerConnection);
    final RTCSessionDescription description = RTCSessionDescription(
      sdp,
      DescriptionType.answer.type,
    );
    await rtcPeerConnection.setLocalDescription(description);

    _wsConnections.answerEstablishSubscriber(targetId: targetId, sdp: sdp);

    // Process queue candidates from server
    final List<RTCIceCandidate> candidates =
        _queueRemoteSubCandidates[targetId] ?? [];

    for (final candidate in candidates) {
      addSubscriberCandidate(targetId, candidate);
    }
  }

  Future<void> _toggleSpeakerPhone() async {
    Helper.setSpeakerphoneOn(true);
  }

  void _notify() {
    _notifyChanged.sink.add(callState());
  }

  @override
  Stream<CallState> get notifyChanged => _notifyChanged.stream;

  @override
  CallState callState() {
    return CallState(
      mParticipant: _mParticipant,
      participants: _subscribers,
    );
  }
}
