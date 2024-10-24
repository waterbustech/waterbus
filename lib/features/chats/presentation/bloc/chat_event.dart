part of 'chat_bloc.dart';

abstract class ChatEvent {}

class OnChatEvent extends ChatEvent {}

class GetConversationsEvent extends ChatEvent {}

class RefreshConversationsEvent extends ChatEvent {
  final Function handleFinish;

  RefreshConversationsEvent({required this.handleFinish});
}

class SelectConversationCurrentEvent extends ChatEvent {
  final Meeting? meeting;
  final int? meetingId;

  SelectConversationCurrentEvent({this.meeting, this.meetingId});
}

class CleanConversationCurrentEvent extends ChatEvent {}

class CreateConversationEvent extends ChatEvent {
  final String title;
  final String password;

  CreateConversationEvent({required this.title, required this.password});
}

class ArchivedConversationEvent extends ChatEvent {
  final Meeting? meeting;

  ArchivedConversationEvent({this.meeting});
}

class DeleteConversationEvent extends ChatEvent {
  final Meeting? meeting;

  DeleteConversationEvent({this.meeting});
}

class LeaveConversationEvent extends ChatEvent {
  final Meeting? meeting;

  LeaveConversationEvent({this.meeting});
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
  final User userModel;

  DeleteMemberEvent({required this.code, required this.userModel});
}

class UpdateConversationEvent extends ChatEvent {
  final String? avatar;
  final String? title;
  final String? password;

  UpdateConversationEvent({this.avatar, this.title, this.password});
}

class UpdateAvatarConversationEvent extends ChatEvent {
  final Uint8List avatar;

  UpdateAvatarConversationEvent({required this.avatar});
}

class UpdateConversationFromSocketEvent extends ChatEvent {}

class UpdateLastMessageEvent extends ChatEvent {
  final MessageModel message;
  final bool isUpdateMessage;

  UpdateLastMessageEvent({
    required this.message,
    this.isUpdateMessage = false,
  });
}

class CleanChatEvent extends ChatEvent {}
