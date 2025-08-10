import 'package:audioplayers/audioplayers.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/settings/domain/entities/notification_settings.dart';
import 'package:waterbus/gen/assets.gen.dart';

@singleton
class RoomSound {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playSoundJoinRoom() async {
    if (!_notificationSetting.participantJoined) return;

    await _audioPlayer.play(
      AssetSource(Assets.sounds.joined.removeAssets),
    );
  }

  Future<void> playSoundLeaveRoom() async {
    if (!_notificationSetting.participantLeft) return;

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
    if (!_notificationSetting.participantRaiseHand) return;

    await _audioPlayer.play(
      AssetSource(Assets.sounds.handRaising.removeAssets),
    );
  }

  NotificationSettings get _notificationSetting =>
      AppBloc.notificationSettingBloc.settings;
}

extension SoundX on String {
  String get removeAssets {
    final res = replaceAll('assets/', '');
    return res;
  }
}
