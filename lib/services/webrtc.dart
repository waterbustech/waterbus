// Package imports:
import 'package:injectable/injectable.dart';

abstract class WebRTCWrapper {
  Future<void> makeCall();
  Future<void> makeAnswer();
  Future<void> getUserMedia();
  Future<void> getDisplayMedia();
  Future<void> setRemoteSdp();
  Future<void> addRemoteCandidate();
  Future<void> dispose();
}

@LazySingleton(as: WebRTCWrapper)
class WebRTCWrapperImpl extends WebRTCWrapper {
  @override
  Future<void> addRemoteCandidate() {
    throw UnimplementedError();
  }

  @override
  Future<void> dispose() {
    throw UnimplementedError();
  }

  @override
  Future<void> getDisplayMedia() {
    throw UnimplementedError();
  }

  @override
  Future<void> getUserMedia() {
    throw UnimplementedError();
  }

  @override
  Future<void> makeAnswer() {
    throw UnimplementedError();
  }

  @override
  Future<void> makeCall() {
    throw UnimplementedError();
  }

  @override
  Future<void> setRemoteSdp() {
    throw UnimplementedError();
  }
}
