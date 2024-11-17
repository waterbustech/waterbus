part of 'chat_bloc.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatActive extends ChatState {
  final List<Meeting> conversations;
  final Meeting? conversationCurrent;

  ChatActive({
    required this.conversations,
    required this.conversationCurrent,
  });
}

class ChatInProgress extends ChatActive {
  ChatInProgress({
    required super.conversations,
    required super.conversationCurrent,
  });
}

class ChatDone extends ChatActive {
  ChatDone({
    required super.conversations,
    required super.conversationCurrent,
  });
}
