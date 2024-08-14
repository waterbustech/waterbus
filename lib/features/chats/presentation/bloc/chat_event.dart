part of 'chat_bloc.dart';

abstract class ChatEvent {}

class OnChatEvent extends ChatEvent {}

class GetConversationsEvent extends ChatEvent {}

class RefreshConversationsEvent extends ChatEvent {
  final Function handleFinish;

  RefreshConversationsEvent({required this.handleFinish});
}

class SelectConversationCurrentEvent extends ChatEvent {
  final Meeting meeting;

  SelectConversationCurrentEvent({required this.meeting});
}

class CleanConversationCurrentEvent extends ChatEvent {}

class CreateConversationEvent extends ChatEvent {
  final String title;
  final String password;

  CreateConversationEvent({required this.title, required this.password});
}

class DeleteOrLeaveConversationEvent extends ChatEvent {
  final Meeting meeting;

  DeleteOrLeaveConversationEvent({required this.meeting});
}

class DeleteConversationByHostEvent extends ChatEvent {
  final int meetingId;

  DeleteConversationByHostEvent({required this.meetingId});
}

class LeaveConversationByMemberEvent extends ChatEvent {
  final Meeting meeting;

  LeaveConversationByMemberEvent({required this.meeting});
}

class AddMemberEvent extends ChatEvent {
  final int code;
  final User user;
  final int meeting;

  AddMemberEvent({
    required this.code,
    required this.user,
    required this.meeting,
  });
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
  final MessageModel message;

  UpdateLastMessageEvent({
    required this.message,
  });
}

class CleanChatEvent extends ChatEvent {}
