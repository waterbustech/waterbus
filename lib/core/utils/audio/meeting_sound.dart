import 'package:audioplayers/audioplayers.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus/gen/assets.gen.dart';

@singleton
class RoomSound {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playSoundJoinRoom() async {
    await _audioPlayer.play(
      AssetSource(Assets.sounds.joined.removeAssets),
    );
  }

  Future<void> playSoundLeaveRoom() async {
    await _audioPlayer.play(
      AssetSource(Assets.sounds.leave.removeAssets),
    );
  }

  Future<void> playSoundRecording() async {
    await _audioPlayer.play(
      AssetSource(Assets.sounds.recording.removeAssets),
    );
  }

  Future<void> playSoundRaiseHand() async {
    await _audioPlayer.play(
      AssetSource(Assets.sounds.handRaising.removeAssets),
    );
  }
}

extension SoundX on String {
  String get removeAssets {
    final res = replaceAll('assets/', '');
    return res;
  }
}
