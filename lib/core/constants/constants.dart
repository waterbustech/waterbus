import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/gen/assets.gen.dart';

const String kAppVersion = 'v1.2.0';
const String kAppTitle = 'Waterbus';
const String kGithubRepo = 'https://github.com/lambiengcode/waterbus';
const String kWaterbusDocs = 'https://docs.waterbus.tech';

// Aspect ratio meet view
const double k35 = 3 / 5;
const double k43 = 4 / 3;
const double k169 = 16 / 9;
const double k11 = 1;

const int defaultLengthOfShimmerList = 10;
const int defaultLengthOfMessages = 30;

final User kUserDefault = User(
  id: 0,
  fullName: 'Waterbus',
  userName: 'waterbus.tech',
  avatar:
      'https://is1-ssl.mzstatic.com/image/thumb/Purple126/v4/32/34/d4/3234d466-75a0-81fa-68f2-65591f2d385c/AppIcon-0-0-1x_U007emarketing-0-0-0-4-0-0-0-85-220.png/512x512bb.jpg',
);

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
