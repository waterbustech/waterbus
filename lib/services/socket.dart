// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart';

// Project imports:
import 'package:waterbus/core/constants/api_endpoints.dart';
import 'package:waterbus/core/constants/socket_event.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting_bloc.dart';

abstract class SocketConnection {
  void establishConnection({
    bool forceConnection = false,
  });
  void disconnection();
  void establishBroadcast({
    required String sdp,
    required String roomId,
    required String participantId,
  });
  void requestEstablishSubscriber({
    required String targetId,
  });
  void answerEstablishSubscriber({
    required String targetId,
    required String sdp,
  });
  void sendBroadcastCandidate(
    RTCIceCandidate candidate,
  );
  void sendReceiverCandidate({
    required RTCIceCandidate candidate,
    required targetId,
  });
  void leaveRoom(
    String roomId,
  );
}

@LazySingleton(as: SocketConnection)
class SocketConnectionImpl extends SocketConnection {
  final AuthLocalDataSource _dataSource;
  SocketConnectionImpl(this._dataSource);

  Socket? _socket;

  @override
  void establishConnection({bool forceConnection = false}) {
    if (_socket != null && !forceConnection) return;

    _socket = io(
      ApiEndpoints.wsUrl,
      OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .enableForceNew()
          .setAuth(
            {
              'Authorization': 'Bearer ${_dataSource.accessToken}',
            },
          )
          .build(),
    );

    _socket?.connect();

    _socket?.onConnect((_) async {
      debugPrint('established connection - sid: ${_socket?.id}');

      _socket?.on(SocketEvent.broadcastSSC, (data) {
        // pc context: only send peer
        // will receive sdp remote from service side if you join success
        /// otherParticipants, sdp (data)
        ///

        if (data == null) return;

        AppBloc.meetingBloc.add(
          EstablishBroadcastSuccessEvent(
            sdp: data['sdp'],
            participants: ((data['otherParticipants'] ?? []) as List)
                .map((e) => e.toString())
                .toList(),
          ),
        );
      });

      _socket?.on(SocketEvent.newParticipantSSC, (data) {
        // will receive signal when someone join,
        /// targetId
        ///
        if (data == null) return;

        AppBloc.meetingBloc.add(
          NewParticipantEvent(participantId: data['targetId']),
        );
      });

      _socket?.on(SocketEvent.sendReceiverSdpSSC, (data) {
        // pc context: only receive peer
        // will receive sdp, get it and add to pc
        /// sdp, targetId
        ///
        if (data['sdp'] == null) return;

        AppBloc.meetingBloc.add(
          EstablishReceiverSuccessEvent(
            participantId: data['targetId'],
            sdp: data['sdp'],
          ),
        );
      });

      _socket?.on(SocketEvent.participantHasLeftSSC, (data) {
        /// targetId
        ///
        if (data == null) return;

        AppBloc.meetingBloc.add(
          ParticipantHasLeftEvent(participantId: data['targetId']),
        );
      });

      _socket?.on(SocketEvent.sendBroadcastCandidateSSC, (data) {
        /// candidate json
        ///
        if (data == null) return;

        AppBloc.meetingBloc.add(
          NewBroadcastCandidateEvent(
            candidate: RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          ),
        );
      });

      _socket?.on(SocketEvent.sendReceiverCandidateSSC, (data) {
        /// targetId, candidate json
        ///
        if (data == null) return;

        final Map<String, dynamic> candidate = data['candidate'];

        AppBloc.meetingBloc.add(
          NewReceiverCandidateEvent(
            targetId: data['targetId'],
            candidate: RTCIceCandidate(
              candidate['candidate'],
              candidate['sdpMid'],
              candidate['sdpMLineIndex'],
            ),
          ),
        );
      });
    });
  }

  @override
  void disconnection() {
    if (_socket == null) return;

    _socket?.disconnect();
    _socket = null;
  }

  // MARK: emit functions
  @override
  void establishBroadcast({
    required String sdp,
    required String roomId,
    required String participantId,
  }) {
    _socket?.emit(SocketEvent.broadcastCSS, {
      "roomId": roomId,
      "sdp": sdp,
      "participantId": participantId,
    });
  }

  @override
  void leaveRoom(String roomId) {
    _socket?.emit(SocketEvent.sendLeaveRoomCSS, {"roomId": roomId});
  }

  @override
  void sendBroadcastCandidate(RTCIceCandidate candidate) {
    _socket?.emit(
      SocketEvent.sendBroadcastCandidateCSS,
      candidate.toMap(),
    );
  }

  @override
  void sendReceiverCandidate({
    required RTCIceCandidate candidate,
    required targetId,
  }) {
    _socket?.emit(SocketEvent.sendReceiverCandidateCSS, {
      'targetId': targetId,
      'candidate': candidate.toMap(),
    });
  }

  @override
  void answerEstablishSubscriber({
    required String targetId,
    required String sdp,
  }) {
    _socket?.emit(SocketEvent.sendReceiverSdpCSS, {
      "targetId": targetId,
      "sdp": sdp,
    });
  }

  @override
  void requestEstablishSubscriber({
    required String targetId,
  }) {
    _socket?.emit(SocketEvent.requestEstablishSubscriberCSS, {
      "targetId": targetId,
    });
  }
}
