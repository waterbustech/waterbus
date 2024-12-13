part of 'invited_chat_bloc.dart';

abstract class InvitedChatState {}

class InvitedChatInitial extends InvitedChatState {}

class InvitedChatActived extends InvitedChatState {
  final List<Meeting> invitedConversations;

  InvitedChatActived({required this.invitedConversations});
}

class InvitedChatInProgress extends InvitedChatActived {
  InvitedChatInProgress({
    required super.invitedConversations,
  });
}

class InvitedChatDone extends InvitedChatActived {
  InvitedChatDone({
    required super.invitedConversations,
  });
}
