part of 'chat_bloc.dart';

abstract class ChatEvent {}

class ChatStarted extends ChatEvent {}

class ChatFetched extends ChatEvent {}

class ChatRefreshed extends ChatEvent {
  final Function handleFinish;

  ChatRefreshed({required this.handleFinish});
}

class ChatCurrentConversationSelected extends ChatEvent {
  final Meeting? meeting;
  final int? meetingId;

  ChatCurrentConversationSelected({this.meeting, this.meetingId});
}

class ChatCurrentConversationCleaned extends ChatEvent {}

class ChatCreated extends ChatEvent {
  final String title;
  final String password;

  ChatCreated({required this.title, required this.password});
}

class ChatArchived extends ChatEvent {
  final Meeting? meeting;

  ChatArchived({this.meeting});
}

class ChatDeleted extends ChatEvent {
  final Meeting? meeting;

  ChatDeleted({this.meeting});
}

class ChatLeft extends ChatEvent {
  final Meeting? meeting;

  ChatLeft({this.meeting});
}

class ChatMemberAdded extends ChatEvent {
  final int code;
  final User user;
  final int meeting;

  ChatMemberAdded({
    required this.code,
    required this.user,
    required this.meeting,
  });
}

class ChatInserted extends ChatEvent {
  final Meeting conversation;

  ChatInserted({required this.conversation});
}

class ChatMemberDeleted extends ChatEvent {
  final int code;
  final User userModel;

  ChatMemberDeleted({required this.code, required this.userModel});
}

class ChatUpdated extends ChatEvent {
  final String? avatar;
  final String? title;
  final String? password;

  ChatUpdated({this.avatar, this.title, this.password});
}

class ChatAvatarUpdated extends ChatEvent {
  final Uint8List avatar;

  ChatAvatarUpdated({required this.avatar});
}

class ChatSocketConversationUpdated extends ChatEvent {}

class ChatLatestMessageUpdated extends ChatEvent {
  final MessageModel message;
  final bool isUpdateMessage;

  ChatLatestMessageUpdated({
    required this.message,
    this.isUpdateMessage = false,
  });
}

class ChatCleaned extends ChatEvent {}
