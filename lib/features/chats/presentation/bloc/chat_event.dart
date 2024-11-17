part of 'chat_bloc.dart';

abstract class ChatEvent {}

class ChatStarted extends ChatEvent {}

class ChatGet extends ChatEvent {}

class ChatRefresh extends ChatEvent {
  final Function handleFinish;

  ChatRefresh({required this.handleFinish});
}

class ChatSelectTheCurrent extends ChatEvent {
  final Meeting? meeting;
  final int? meetingId;

  ChatSelectTheCurrent({this.meeting, this.meetingId});
}

class ChatCleanConversationCurrent extends ChatEvent {}

class ChatCreate extends ChatEvent {
  final String title;
  final String password;

  ChatCreate({required this.title, required this.password});
}

class ChatArchived extends ChatEvent {
  final Meeting? meeting;

  ChatArchived({this.meeting});
}

class ChatDelete extends ChatEvent {
  final Meeting? meeting;

  ChatDelete({this.meeting});
}

class ChatLeave extends ChatEvent {
  final Meeting? meeting;

  ChatLeave({this.meeting});
}

class ChatAddMember extends ChatEvent {
  final int code;
  final User user;
  final int meeting;

  ChatAddMember({
    required this.code,
    required this.user,
    required this.meeting,
  });
}

class ChatInsert extends ChatEvent {
  final Meeting conversation;

  ChatInsert({required this.conversation});
}

class ChatDeleteMember extends ChatEvent {
  final int code;
  final User userModel;

  ChatDeleteMember({required this.code, required this.userModel});
}

class ChatUpdate extends ChatEvent {
  final String? avatar;
  final String? title;
  final String? password;

  ChatUpdate({this.avatar, this.title, this.password});
}

class ChatUpdateAvatar extends ChatEvent {
  final Uint8List avatar;

  ChatUpdateAvatar({required this.avatar});
}

class ChatUpdateConversationFromSocket extends ChatEvent {}

class ChatUpdateLastMessage extends ChatEvent {
  final MessageModel message;
  final bool isUpdateMessage;

  ChatUpdateLastMessage({
    required this.message,
    this.isUpdateMessage = false,
  });
}

class ChatClean extends ChatEvent {}
