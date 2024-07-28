part of 'chat_bloc.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ActiveChatState extends ChatState {
  final List<Meeting> conversations;
  final Meeting? conversationCurrent;

  ActiveChatState({
    required this.conversations,
    required this.conversationCurrent,
  });
}

class GettingChatState extends ActiveChatState {
  GettingChatState({
    required super.conversations,
    required super.conversationCurrent,
  });
}

class GetDoneChatState extends ActiveChatState {
  GetDoneChatState({
    required super.conversations,
    required super.conversationCurrent,
  });
}
