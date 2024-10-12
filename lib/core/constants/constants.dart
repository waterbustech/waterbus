import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/gen/assets.gen.dart';

const String kAppTitle = 'Waterbus';
const String kGithubRepo = 'https://github.com/lambiengcode/waterbus';
const String kWaterbusDocs = 'https://docs.waterbus.tech';

const vietnamese = 'aAeEoOuUiIdDyY';
const String regExpspecialCharacters =
    r'(?:[\u2700-\u27bf]|(?:\ud83c[\udde6-\uddff]){2}|[\ud800-\udbff][\udc00-\udfff]|[\u0023-\u0039]\ufe0f?\u20e3|\u3299|\u3297|\u303d|\u3030|\u24c2|\ud83c[\udd70-\udd71]|\ud83c[\udd7e-\udd7f]|\ud83c\udd8e|\ud83c[\udd91-\udd9a]|\ud83c[\udde6-\uddff]|\ud83c[\ude01-\ude02]|\ud83c\ude1a|\ud83c\ude2f|\ud83c[\ude32-\ude3a]|\ud83c[\ude50-\ude51]|\u203c|\u2049|[\u25aa-\u25ab]|\u25b6|\u25c0|[\u25fb-\u25fe]|\u00a9|\u00ae|\u2122|\u2139|\ud83c\udc04|[\u2600-\u26FF]|\u2b05|\u2b06|\u2b07|\u2b1b|\u2b1c|\u2b50|\u2b55|\u231a|\u231b|\u2328|\u23cf|[\u23e9-\u23f3]|[\u23f8-\u23fa]|\ud83c\udccf|\u2934|\u2935|[\u2190-\u21ff])';
final vietnameseRegex = <RegExp>[
  RegExp('à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ'),
  RegExp('À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ'),
  RegExp('è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ'),
  RegExp('È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ'),
  RegExp('ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ'),
  RegExp('Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ'),
  RegExp('ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ'),
  RegExp('Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ'),
  RegExp('ì|í|ị|ỉ|ĩ'),
  RegExp('Ì|Í|Ị|Ỉ|Ĩ'),
  RegExp('đ'),
  RegExp('Đ'),
  RegExp('ỳ|ý|ỵ|ỷ|ỹ'),
  RegExp('Ỳ|Ý|Ỵ|Ỷ|Ỹ'),
  RegExp('\u0300|\u0301|\u0303|\u0309|\u0323'),
  RegExp('\u02C6|\u0306|\u031B'),
];
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
