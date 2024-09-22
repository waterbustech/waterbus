part of 'invited_chat_bloc.dart';

abstract class InvitedChatState {}

class InvitedChatInitial extends InvitedChatState {}

class ActiveInvitedChatState extends InvitedChatState {
  final List<Meeting> invitedConversations;

  ActiveInvitedChatState({
    required this.invitedConversations,
  });
}

class GetDoneInvitedChatState extends ActiveInvitedChatState {
  GetDoneInvitedChatState({
    required super.invitedConversations,
  });
}

class GettingInvitedChatState extends ActiveInvitedChatState {
  GettingInvitedChatState({
    required super.invitedConversations,
  });
}
