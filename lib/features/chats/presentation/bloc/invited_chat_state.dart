part of 'invited_chat_bloc.dart';

abstract class InvitedChatState {}

class InvitedChatInitial extends InvitedChatState {}

class InvitedChatActive extends InvitedChatState {
  final List<Meeting> invitedConversations;

  InvitedChatActive({required this.invitedConversations});
}

class InvitedChatInProgress extends InvitedChatActive {
  InvitedChatInProgress({
    required super.invitedConversations,
  });
}

class InvitedChatDone extends InvitedChatActive {
  InvitedChatDone({
    required super.invitedConversations,
  });
}
