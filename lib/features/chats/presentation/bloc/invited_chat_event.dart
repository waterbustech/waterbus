part of 'invited_chat_bloc.dart';

abstract class InvitedChatEvent {}

class OnInvitedConversationEvent extends InvitedChatEvent {}

class GetInvitedConversationsEvent extends InvitedChatEvent {}

class RefreshInvitedConversationsEvent extends InvitedChatEvent {
  final Function handleFinish;

  RefreshInvitedConversationsEvent({required this.handleFinish});
}

class AcceptInviteEvent extends InvitedChatEvent {
  final int code;

  AcceptInviteEvent({required this.code});
}

class CleanInvitedConversationEvent extends InvitedChatEvent {}
