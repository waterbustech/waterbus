part of 'chat_bloc.dart';

abstract class ChatEvent {}

class ChatStarted extends ChatEvent {}

class ChatFetched extends ChatEvent {}

class ChatRefreshed extends ChatEvent {
  final Function handleFinish;

  ChatRefreshed({required this.handleFinish});
}

class ChatCurrentConversationSelected extends ChatEvent {
  final Room? room;
  final int? roomId;

  ChatCurrentConversationSelected({this.room, this.roomId});
}

class ChatCurrentConversationCleaned extends ChatEvent {}

class ChatCreated extends ChatEvent {
  final String title;
  final String password;

  ChatCreated({required this.title, required this.password});
}

class ChatArchived extends ChatEvent {
  final Room? room;

  ChatArchived({this.room});
}

class ChatDeleted extends ChatEvent {
  final Room? room;

  ChatDeleted({this.room});
}

class ChatLeft extends ChatEvent {
  final Room? room;

  ChatLeft({this.room});
}

class ChatMemberAdded extends ChatEvent {
  final User user;
  final int roomId;

  ChatMemberAdded({
    required this.user,
    required this.roomId,
  });
}

class ChatInserted extends ChatEvent {
  final Room conversation;

  ChatInserted({required this.conversation});
}

class ChatMemberDeleted extends ChatEvent {
  final int roomId;
  final User userModel;

  ChatMemberDeleted({required this.roomId, required this.userModel});
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
  final Message message;
  final bool isUpdateMessage;

  ChatLatestMessageUpdated({
    required this.message,
    this.isUpdateMessage = false,
  });
}

class ChatCleaned extends ChatEvent {}
