// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart';

// Project imports:
import 'package:waterbus/core/constants/api_endpoints.dart';
import 'package:waterbus/core/constants/socket_event.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting_bloc.dart';

abstract class SocketConnection {
  void establishConnection({bool forceConnection = false});
  void disconnection();
  void establishBroadcast({
    required String sdp,
    required String roomId,
    required String participantId,
  });
  void establishReceiver({
    required String roomId,
    required String targetId,
    required String sdp,
  });
  void leaveRoom(String roomId);
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

    _socket?.onError((data) => debugPrint(data));

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
            participants: data['otherParticipants'],
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
        if (data == null) return;

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
  void establishReceiver({
    required String roomId,
    required String targetId,
    required String sdp,
  }) {
    _socket?.emit(SocketEvent.sendReceiverSdpCSS, {
      "roomId": roomId,
      "targetId": targetId,
      "sdp": sdp,
    });
  }

  @override
  void leaveRoom(String roomId) {
    _socket?.emit(SocketEvent.sendLeaveRoomCSS, {"roomId": roomId});
  }
}
