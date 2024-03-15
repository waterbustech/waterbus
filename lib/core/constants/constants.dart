// Package imports:
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

// Project imports:
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/gen/assets.gen.dart';

const User userDefault = User(
  id: 0,
  fullName: 'Waterbus',
  userName: 'waterbus.tech',
  avatar: 'https://avatars.githubusercontent.com/u/60530946?v=4',
);

const gridViewMinUsers = 4;

final Map<String, BeautyFilter> filters = {
  'Normal': BeautyFilter(),
  'Classic': BeautyFilter(
    contrast: 1.1,
    saturation: 1.2,
    noiseReduction: 0.1,
  ),
  'Vintage': BeautyFilter(
    brightness: 0.9,
    saturation: 1.1,
    blurRadius: 3,
    noiseReduction: 0.1,
  ),
  'Black and White': BeautyFilter(
    contrast: 1.3,
    saturation: 0.0,
  ),
  'Sepia': BeautyFilter(
    brightness: 0.9,
    saturation: 0.8,
  ),
  'HDR': BeautyFilter(
    contrast: 1.2,
    brightness: 1.1,
  ),
  'Soft Glow': BeautyFilter(
    brightness: 1.1,
    blurRadius: 3,
  ),
  'Cool Blue': BeautyFilter(
    saturation: 0.8,
    blurRadius: 3,
  ),
  'Pop Art': BeautyFilter(
    contrast: 1.2,
    brightness: 1.1,
    saturation: 1.5,
  ),
  'Cinema': BeautyFilter(
    contrast: 0.8,
    brightness: 0.9,
    blurRadius: 3,
    noiseReduction: 0.2,
  ),
  'Dramatic': BeautyFilter(
    contrast: 1.3,
    brightness: 0.8,
  ),
  'Pastel': BeautyFilter(
    contrast: 0.9,
    saturation: 1.3,
    blurRadius: 3,
  ),
  'Faded': BeautyFilter(
    contrast: 0.8,
    brightness: 0.9,
    saturation: 0.7,
    blurRadius: 3,
  ),
};

final List<String> backgrounds = [
  Assets.images.background1Jpg.path,
  Assets.images.background2Jpg.path,
  Assets.images.background3Jpg.path,
  Assets.images.background4Jpg.path,
  Assets.images.background5Jpg.path,
];

final List<String> desktopBackgrounds = [
  Assets.images.desktopBackground1Jpg.path,
  Assets.images.desktopBackground2Jpg.path,
  Assets.images.desktopBackground3Jpg.path,
  Assets.images.desktopBackground4Jpg.path,
  Assets.images.desktopBackground5Jpg.path,
  Assets.images.desktopBackground6Jpg.path,
  Assets.images.desktopBackground7Jpg.path,
  Assets.images.desktopBackground8Jpg.path,
  Assets.images.desktopBackground9Jpg.path,
];
