import 'package:i18n_extension/i18n_extension.dart';
import 'package:waterbus/core/app/lang/data/english.dart';
import 'package:waterbus/core/app/lang/data/vietnamese.dart';

class Strings {
  static const String countryflags = 'countryflags';
  static const String selectLanguage = 'selectLanguage';
  static const String today = 'today';
  static const String cut = 'cut';
  static const String copy = 'copy';
  static const String paste = 'paste';
  static const String entireScreen = 'entireScreen';
  static const String window = 'window';
  static const String cancel = 'cancel';
  static const String share = 'share';
  static const String notifications = 'notifications';
  static const String home = 'home';
  static const String save = 'save';
  static const String fullName = 'fullName';
  static const String invalidFullName = 'invalidFullName';
  static const String yourFullName = 'yourFullName';
  static const String profile = 'profile';
  static const String settings = 'settings';
  static const String licenses = 'licenses';
  static const String logout = 'logout';
  static const String schedule = 'schedule';
  static const String general = 'general';
  static const String lowBandwidthMode = 'lowBandwidthMode';
  static const String audio = 'audio';
  static const String startWithAudioMuted = 'startWithAudioMuted';
  static const String echoCancellation = 'echoCancellation';
  static const String noiseSuppression = 'noiseSuppression';
  static const String automaticGainControl = 'automaticGainControl';
  static const String video = 'video';
  static const String startWithVideoMuted = 'startWithVideoMuted';
  static const String videoQuality = 'videoQuality';
  static const String security = 'security';
  static const String endToEndEncryption = 'endToEndEncryption';
  static const String videoLayout = 'videoLayout';
  static const String gridView = 'gridView';
  static const String listView = 'listView';
  static const String preferredCodec = 'preferredCodec';
  static const String roomName = 'roomName';
  static const String invalidName = 'invalidName';
  static const String meetingLabel = 'meetingLabel';
  static const String passwordMustBeAtLeast6Characters =
      'passwordMustBeAtLeast6Characters';
  static const String password = 'password';
  static const String smooth = 'smooth';
  static const String white = 'white';
  static const String thinFace = 'thinFace';
  static const String bigEyes = 'bigEyes';
  static const String lipstick = 'lipstick';
  static const String blusher = 'blusher';
  static const String yourMessagesAndMeetingsArePrivate =
      'yourMessagesAndMeetingsArePrivate';
  static const String
      endToEndEncryptionKeepsYourPersonalMeetingsBetweenYouAndTheOtherPeopleNotEvenWaterbusCanListenToThemThisIncludesYour =
      'endToEndEncryptionKeepsYourPersonalMeetingsBetweenYouAndTheOtherPeopleNotEvenWaterbusCanListenToThemThisIncludesYour';
  static const String audioAndVideoCalls = 'audioAndVideoCalls';
  static const String textMessages = 'textMessages';
  static const String chooseWhatToShare = 'chooseWhatToShare';
  static const String enterCodeToJoinMeeting = 'enterCodeToJoinMeeting';
  static const String roomCode = 'roomCode';
  static const String noParticipantsYet = 'noParticipantsYet';
  static const String yourPersonalMeetingsAre = 'yourPersonalMeetingsAre';
  static const String endToEndEncrypted = 'endToEndEncrypted';
  static const String join = 'join';
  static const String joinAMeeting = 'joinAMeeting';
  static const String search = 'search';
  static const String createRoom = 'createRoom';
  static const String chat = 'chat';
  static const String enterPassword = 'enterPassword';
  static const String createMeeting = 'createMeeting';
  static const String editMeeting = 'editMeeting';
  static const String searchYourChat = 'searchYourChat';
    static const String giveUsStar = 'Give us star';
      static const String callSettings = 'callSettings';


}

class MyI18n {
  Map<String, Map<String, String>> get getTranslation => Map.fromEntries(
        vietnamese.keys.map(
          (element) => MapEntry(
            element,
            {'vi_vn': vietnamese[element]!, 'en_us': english[element]!},
          ),
        ),
      );
}

extension Localization on String {
  static final _t = Translations.byId('vi_vn', MyI18n().getTranslation);

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);

  String plural(int value) => localizePlural(value, this, _t);

  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
