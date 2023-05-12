/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/ic_apple.png
  AssetGenImage get icApple => const AssetGenImage('assets/icons/ic_apple.png');

  /// File path: assets/icons/ic_camera_video.png
  AssetGenImage get icCameraVideo =>
      const AssetGenImage('assets/icons/ic_camera_video.png');

  /// File path: assets/icons/ic_end_call.png
  AssetGenImage get icEndCall =>
      const AssetGenImage('assets/icons/ic_end_call.png');

  /// File path: assets/icons/ic_facebook.png
  AssetGenImage get icFacebook =>
      const AssetGenImage('assets/icons/ic_facebook.png');

  /// File path: assets/icons/ic_google.png
  AssetGenImage get icGoogle =>
      const AssetGenImage('assets/icons/ic_google.png');

  /// File path: assets/icons/ic_new_meeting.png
  AssetGenImage get icNewMeeting =>
      const AssetGenImage('assets/icons/ic_new_meeting.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [icApple, icCameraVideo, icEndCall, icFacebook, icGoogle, icNewMeeting];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/img_app_logo.png
  AssetGenImage get imgAppLogo =>
      const AssetGenImage('assets/images/img_app_logo.png');

  /// File path: assets/images/img_logo.png
  AssetGenImage get imgLogo =>
      const AssetGenImage('assets/images/img_logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [imgAppLogo, imgLogo];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
