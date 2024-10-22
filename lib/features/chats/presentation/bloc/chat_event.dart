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

class ArchivedOrLeaveConversationEvent extends ChatEvent {
  final Meeting? meeting;

  ArchivedOrLeaveConversationEvent({this.meeting});
}

class ChangeConversationToArchivedEvent extends ChatEvent {
  final int meetingId;

  ChangeConversationToArchivedEvent({required this.meetingId});
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
