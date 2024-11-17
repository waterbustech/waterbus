part of 'message_bloc.dart';

abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageActice extends MessageState {
  final List<MessageModel> messages;
  final MessageModel? messageBeingEdited;
  final bool isOver;

  MessageActice({
    required this.messages,
    required this.messageBeingEdited,
    required this.isOver,
  });
}

class MessageInProgress extends MessageActice {
  MessageInProgress({
    required super.messages,
    required super.messageBeingEdited,
    required super.isOver,
  });
}

class MessageDone extends MessageActice {
  MessageDone({
    required super.messages,
    required super.messageBeingEdited,
    required super.isOver,
  });
}
