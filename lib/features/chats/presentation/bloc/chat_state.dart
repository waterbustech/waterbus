part of 'chat_bloc.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ActiveChatState extends ChatState {
  final List<Meeting> conversations;
  final List<Meeting> invitedConversations;

  ActiveChatState({
    required this.conversations,
    required this.invitedConversations,
  });
}

class GettingChatState extends ActiveChatState {
  GettingChatState({
    required super.conversations,
    required super.invitedConversations,
  });
}

class GetDoneChatState extends ActiveChatState {
  GetDoneChatState({
    required super.conversations,
    required super.invitedConversations,
  });
}

class GettingInvitedChatState extends ActiveChatState {
  GettingInvitedChatState({
    required super.conversations,
    required super.invitedConversations,
  });
}
