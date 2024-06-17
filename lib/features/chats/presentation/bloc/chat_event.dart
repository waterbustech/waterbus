part of 'chat_bloc.dart';

abstract class ChatEvent {}

class OnChatEvent extends ChatEvent {}

class GetConversationsEvent extends ChatEvent {}

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

class DeleteMemberEvent extends ChatEvent {
  final int code;
  final int userId;

  DeleteMemberEvent({required this.code, required this.userId});
}

class GetInvitedConversations extends ChatEvent {}

class AcceptInviteEvent extends ChatEvent {
  final int code;

  AcceptInviteEvent({required this.code});
}

class CleanChatEvent extends ChatEvent {}
