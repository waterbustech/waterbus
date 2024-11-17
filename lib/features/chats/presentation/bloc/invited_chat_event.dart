part of 'invited_chat_bloc.dart';

abstract class InvitedChatEvent {}

class InvitedChatStarted extends InvitedChatEvent {}

class InvitedChatGet extends InvitedChatEvent {}

class InvitedChatRefresh extends InvitedChatEvent {
  final Function handleFinish;

  InvitedChatRefresh({required this.handleFinish});
}

class InvitedChatInsert extends InvitedChatEvent {
  final Meeting invited;

  InvitedChatInsert({required this.invited});
}

class InvitedChatAccept extends InvitedChatEvent {
  final int meetingId;

  InvitedChatAccept({required this.meetingId});
}

class InvitedChatClean extends InvitedChatEvent {}
