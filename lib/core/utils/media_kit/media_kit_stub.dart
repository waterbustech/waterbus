import 'package:video_player_media_kit/video_player_media_kit.dart';

void initializeMediaKit() {
  VideoPlayerMediaKit.ensureInitialized(
    macOS: true,
    windows: true,
    linux: true,
    web: true,
    android: true,
    iOS: true,
  );
}
