part of 'chat_bloc.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatActived extends ChatState {
  final List<Room> conversations;
  final Room? conversationCurrent;

  ChatActived({
    required this.conversations,
    required this.conversationCurrent,
  });
}

class ChatInProgress extends ChatActived {
  ChatInProgress({
    required super.conversations,
    required super.conversationCurrent,
  });
}

class ChatDone extends ChatActived {
  ChatDone({
    required super.conversations,
    required super.conversationCurrent,
  });
}
