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
  void sendJoinCall();
  void sendSdp();
  void sendCandidate();
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
      OptionBuilder().enableReconnection().enableForceNew().setAuth(
        {
          'Authorization': 'Bearer ${_dataSource.accessToken}',
        },
      ).build(),
    );

    _socket?.connect();

    _socket?.on(SocketEvent.joinCallSSC, (data) {});

    _socket?.on(SocketEvent.newParticipantSSC, (data) {});

    _socket?.on(SocketEvent.sendCandidateSSC, (data) {});

    _socket?.on(SocketEvent.sendSdpSSC, (data) {});
  }

  @override
  void disconnection() {
    if (_socket == null) return;

    _socket?.disconnect();
    _socket = null;
  }

  // MARK: emit functions
  @override
  void sendJoinCall() {
    _socket?.emit(SocketEvent.joinCallCSS);
  }

  @override
  void sendCandidate() {
    _socket?.emit(SocketEvent.sendCandidateCSS);
  }

  @override
  void sendSdp() {
    _socket?.emit(SocketEvent.sendSdpCSS);
  }
}
