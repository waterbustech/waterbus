import 'package:flutter/material.dart';

import 'package:i18n_extension/i18n_extension.dart';

import 'package:waterbus/core/app/lang/data/english.dart';
import 'package:waterbus/core/app/lang/data/vietnamese.dart';

class Strings {
  static const String language = 'language';
  static const String vietnamese = 'vietnamese';
  static const String english = 'english';
  static String darkMode = ThemeMode.dark.name;
  static String lightMode = ThemeMode.light.name;
  static String system = ThemeMode.system.name;
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
  static const String invalidFullName = 'invalidFullName';

  static const String recent = 'recent';
  static const String storage = 'storage';
  static const String talkWithAI = 'talkWithAI';
  static const String archivedChats = 'archivedChats';
  static const String settings = 'settings';
  static const String licenses = 'licenses';
  static const String logout = 'logout';
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
  static const String participationInstructions = 'participationInstructions';
  static const String search = 'search';
  static const String createRoom = 'createRoom';
  static const String chat = 'chats';
  static const String delete = 'delete';
  static const String sureDeleteConversation = 'sureDeleteConversation';
  static const String sureDeleteMessage = 'sureDeleteMessage';
  static const String leaveAMessage = 'leaveAMessage';
  static const String invitedChat = 'invitedChat';
  static const String enterPassword = 'enterPassword';
  static const String createMeeting = 'createMeeting';
  static const String editMeeting = 'editMeeting';
  static const String giveUsStar = 'Give us star';
  static const String callSettings = 'callSettings';
  static const String online = 'online';
  static const String meetingWith = 'meetingWith';
  static const String shareLink = 'shareLink';
  static const String start = 'start';
  static const String dataSaver = 'Data Saver';
  static const String balance = 'Balance';
  static const String highQuality = 'High Quality';
  static const String beautyFilters = 'beautyFilters';
  static const String virtualBackground = 'virtualBackground';
  static const String subtitle = 'subtitle';
  static const String record = 'record';
  static const String duration = 'duration';
  static const String callStats = 'callStats';
  static const String frameSent = 'frameSent';
  static const String resolution = 'resolution';
  static const String latency = 'latency';
  static const String back = 'back';
  static const String saved = 'saved';
  static const String copied = 'copied';
  static const String createdAt = 'createdAt';

  // Profile screen
  static const String profile = 'profile';
  static const String fullname = 'fullname';
  static const String bio = 'bio';
  static const String username = 'username';
  static const String enterYourNameAndAddAnOptionalProfilePhoto =
      'enterYourNameAndAddAnOptionalProfilePhoto';
  static const String youCanAddFewLinesAboutYourself =
      'youCanAddFewLinesAboutYourself';
  static const String usernameNote1 = 'usernameNote1';
  static const String usernameNote2 = 'usernameNote2';
  static const String usernameNote3 = 'usernameNote3';
  static const String usernameNote4 = 'usernameNote4';
  static const String done = 'done';
  static const String canUseUsername = 'canUseUsername';
  static const String usernameUsed = 'usernameUsed';
  static const String checking = 'checking';
  static const String updateUsernameSuccessfully = 'updateUsernameSuccessfully';
  static const String updatedPersonalInformationSuccessfully =
      'updatedPersonalInformationSuccessfully';

  // Settings screen
  static const String myProfile = 'myProfile';
  static const String edit = 'edit';
  static const String appearance = 'appearance';
  static const String colorMode = 'colorMode';
  static const String primaryColor = 'primaryColor';
  static const String callAndMeeting = 'callAndMeeting';
  static const String serverConfiguration = 'serverConfiguration';
  static const String clearCache = 'clearCache';
  static const String version = 'version';
  static const String sizeNotSupported = 'sizeNotSupported';
  static const String changeYourAvatar = 'changeYourAvatar';
  static const String chooseFromGallery = 'chooseFromGallery';
  static const String takeAPhoto = 'takeAPhoto';
  static const String inAppNotification = 'inAppNotification';
  static const String inMeeting = 'inMeeting';
  static const String newMessage = 'newMessage';
  static const String newInvitation = 'newInvitation';
  static const String participantJoined = 'participantJoined';
  static const String participantLeft = 'participantLeft';
  static const String participantRaiseHand = 'participantRaiseHand';

  // Chat Screen
  static const String videoCall = 'videoCall';
  static const String mute = 'mute';
  static const String more = 'more';
  static const String addMembers = 'addMembers';
  static const String owner = 'owner';
  static const String youHaveBeenInvitedToChat = 'youHaveBeenInvitedToChat';
  static const String confirm = 'confirm';
  static const String inviting = 'inviting';
  static const String invisible = 'invisible';
  static const String joined = 'joined';
  static const String leaveTheConversation = 'leaveTheConversation';
  static const String sureLeaveConversation = 'sureLeaveConversation';
  static const String sureArchivedConversation = 'sureArchivedConversation';
  static const String member = 'member';
  static const String members = 'members';
  static const String groupCreated = 'grounpCreated';
  static const String sending = 'sending';
  static const String canNotSend = 'canNotSend';
  static const String resend = 'resend';
  static const String you = 'you';
  static const String user = 'user';
  static const String unsentAMessage = 'unsentAMessage';
  static const String hi = 'hi';
  static const String noMesssagesHereYet = 'noMesssagesHereYet';
  static const String youHaveInvitedThe = 'youHaveInvitedThe';
  static const String toJoinConversation = 'toJoinConversation';
  static const String deleteMember = 'deleteMember';
  static const String addConversationSuccess = 'addConversationSuccess';
  static const String sureDeleteMember = 'sureDeleteMember';
  static const String youHaveConfirmedConversation = "youConfirmedConversation";
  static const String hostCanNotDeleteConversation =
      'hostCanNotDeleteConversation';
  static const String sendMessageOrTapOnTheGreetingBelow =
      'sendMessageOrTapOnTheGreetingBelow';
  static const String chatUpdatedSuccessfully =
      'theConversationUpdateWasSuccessful';
  static const String chatUpdateFailed = 'chatUpdateFailed';
  static const String uploadImageFail = 'uploadImageFail';
  static const String setNewPhoto = 'setNewPhoto';
  static const String leaveGroup = 'leaveGroup';
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
