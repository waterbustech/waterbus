part of 'invited_chat_bloc.dart';

abstract class InvitedChatEvent {}

class InvitedChatStarted extends InvitedChatEvent {}

class InvitedChatFetched extends InvitedChatEvent {}

class InvitedChatRefreshed extends InvitedChatEvent {
  final Function handleFinish;

  InvitedChatRefreshed({required this.handleFinish});
}

class InvitedChatInserted extends InvitedChatEvent {
  final Meeting invited;

  InvitedChatInserted({required this.invited});
}

class InvitedChatAccepted extends InvitedChatEvent {
  final int meetingId;

  InvitedChatAccepted({required this.meetingId});
}

class InvitedChatCleaned extends InvitedChatEvent {}
