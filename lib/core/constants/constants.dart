// Project imports:
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/gen/assets.gen.dart';

const String kGithubRepo = 'https://github.com/lambiengcode/waterbus';
const String kWaterbusDocs = 'https://docs.waterbus.tech';

const User kUserDefault = User(
  id: 0,
  fullName: 'Waterbus',
  userName: 'waterbus.tech',
  avatar: 'https://avatars.githubusercontent.com/u/60530946?v=4',
);

const kGridViewMinUsers = 4;

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

// Tab Option Setting Screen
const String profileTab = '/myProfile';
const String appearanceTab = '/appearance';
const String languageTab = '/language';
const String callAndMeetingTab = '/callAndMeeting';
