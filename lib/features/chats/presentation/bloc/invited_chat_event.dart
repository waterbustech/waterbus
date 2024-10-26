part of 'invited_chat_bloc.dart';

abstract class InvitedChatEvent {}

class OnInvitedConversationEvent extends InvitedChatEvent {}

class GetInvitedConversationsEvent extends InvitedChatEvent {}

class RefreshInvitedConversationsEvent extends InvitedChatEvent {
  final Function handleFinish;

  RefreshInvitedConversationsEvent({required this.handleFinish});
}

class InsertInvitedConversationsEvent extends InvitedChatEvent {
  final Meeting invited;

  InsertInvitedConversationsEvent({required this.invited});
}

class AcceptInviteEvent extends InvitedChatEvent {
  final int meetingId;

  AcceptInviteEvent({required this.meetingId});
}

class CleanInvitedConversationEvent extends InvitedChatEvent {}
