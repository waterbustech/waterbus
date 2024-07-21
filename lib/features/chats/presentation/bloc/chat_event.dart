part of 'chat_bloc.dart';

abstract class ChatEvent {}

class OnChatEvent extends ChatEvent {}

class GetConversationsEvent extends ChatEvent {}

class RefreshConversationsEvent extends ChatEvent {
  final Function handleFinish;

  RefreshConversationsEvent({required this.handleFinish});
}

class CreateConversationEvent extends ChatEvent {
  final String title;
  final String password;

  CreateConversationEvent({required this.title, required this.password});
}

class DeleteConversationEvent extends ChatEvent {
  final int meetingId;

  DeleteConversationEvent({required this.meetingId});
}

class AddMemberEvent extends ChatEvent {
  final int code;
  final int userId;

  AddMemberEvent({required this.code, required this.userId});
}

class InsertConversationEvent extends ChatEvent {
  final Meeting conversation;

  InsertConversationEvent({required this.conversation});
}

class DeleteMemberEvent extends ChatEvent {
  final int code;
  final int userId;

  DeleteMemberEvent({required this.code, required this.userId});
}

class UpdateLastMessageEvent extends ChatEvent {
  final int meetingId;
  final MessageModel message;

  UpdateLastMessageEvent({
    required this.meetingId,
    required this.message,
  });
}

class CleanChatEvent extends ChatEvent {}
