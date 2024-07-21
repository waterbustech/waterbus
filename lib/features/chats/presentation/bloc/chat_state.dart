part of 'chat_bloc.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ActiveChatState extends ChatState {
  final List<Meeting> conversations;

  ActiveChatState({required this.conversations});
}

class GettingChatState extends ActiveChatState {
  GettingChatState({
    required super.conversations,
  });
}

class GetDoneChatState extends ActiveChatState {
  GetDoneChatState({
    required super.conversations,
  });
}
