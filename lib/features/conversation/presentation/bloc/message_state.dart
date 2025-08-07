part of 'message_bloc.dart';

abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageActived extends MessageState {
  final List<Message> messages;
  final Message? messageBeingEdited;
  final bool isOver;

  MessageActived({
    required this.messages,
    required this.messageBeingEdited,
    required this.isOver,
  });
}

class MessageInProgress extends MessageActived {
  MessageInProgress({
    required super.messages,
    required super.messageBeingEdited,
    required super.isOver,
  });
}

class MessageDone extends MessageActived {
  MessageDone({
    required super.messages,
    required super.messageBeingEdited,
    required super.isOver,
  });
}
