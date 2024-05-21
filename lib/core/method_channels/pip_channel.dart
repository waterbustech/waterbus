import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import 'package:injectable/injectable.dart';

import 'package:waterbus/core/constants/channel_name.dart';

@singleton
class PipChannel {
  final MethodChannel _pipChannel = const MethodChannel(kPipChannel);

  DateTime _latestUpdate = DateTime.now();
  String _currentRemote = '';
  bool _isCreatedPip = false;

  Future<void> startPip({
    required String remoteStreamId,
    required String peerConnectionId,
    required String myAvatar,
    required String remoteAvatar,
    required String remoteName,
    required bool isRemoteCameraEnable,
  }) async {
    if (!Platform.isIOS ||
        DateTime.now().difference(_latestUpdate).inSeconds <= 2) return;

    if (_isCreatedPip) {
      if (_currentRemote == remoteStreamId) {
        _pipChannel.invokeMethod("updateState", {
          "isRemoteCameraEnable": isRemoteCameraEnable,
        });
      } else {
        _currentRemote = remoteStreamId;
        _pipChannel.invokeMethod("updatePictureInPicture", {
          "remoteStreamId": remoteStreamId,
          "peerConnectionId": peerConnectionId,
          "isRemoteCameraEnable": isRemoteCameraEnable,
          "remoteAvatar": remoteAvatar,
          "remoteName": remoteName,
        });
      }
    } else {
      _currentRemote = remoteStreamId;
      _isCreatedPip = true;
      _pipChannel.invokeMethod("startPictureInPicture", {
        "remoteStreamId": remoteStreamId,
        "peerConnectionId": peerConnectionId,
        "isRemoteCameraEnable": isRemoteCameraEnable,
        "myAvatar": myAvatar,
        "remoteAvatar": remoteAvatar,
        "remoteName": remoteName,
      });
    }

    _latestUpdate = DateTime.now();
  }

  void stopPip() {
    if (!_isCreatedPip) return;

    _isCreatedPip = false;
    _currentRemote = '';
    _pipChannel.invokeMethod("stopPictureInPicture");
  }
}
