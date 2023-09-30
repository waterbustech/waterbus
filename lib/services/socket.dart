// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart';

// Project imports:
import 'package:waterbus/core/constants/api_endpoints.dart';
import 'package:waterbus/core/constants/socket_event.dart';
import 'package:waterbus/features/auth/data/datasources/auth_local_datasource.dart';

abstract class SocketConnection {
  void establishConnection({bool forceConnection = false});
  void disconnection();
  void establishBroadcast({required String sdp, required String roomId});
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
              'authorization': 'Bearer ${_dataSource.accessToken}',
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
      });

      _socket?.on(SocketEvent.newParticipantSSC, (data) {
        // will receive signal when someone join,
      });

      _socket?.on(SocketEvent.sendReceiverSdpSSC, (data) {
        // pc context: only receive peer
        // will receive sdp, get it and add to pc
      });

      _socket?.on(SocketEvent.participantHasLeftSSC, (data) {});
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
  void establishBroadcast({required String sdp, required String roomId}) {
    _socket?.emit(SocketEvent.broadcastCSS, {
      "roomId": roomId,
      "sdp": sdp,
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
