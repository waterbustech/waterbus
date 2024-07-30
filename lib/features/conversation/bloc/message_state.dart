part of 'message_bloc.dart';

abstract class MessageState {}

class MessageInitial extends MessageState {}

class ActiveMessageState extends MessageState {
  final List<MessageModel> messages;
  final MessageModel? messageBeingEdited;
  final bool isOver;

  ActiveMessageState({
    required this.messages,
    required this.messageBeingEdited,
    required this.isOver,
  });
}

class GettingMessageState extends ActiveMessageState {
  GettingMessageState({
    required super.messages,
    required super.messageBeingEdited,
    required super.isOver,
  });
}

class GetDoneMessageState extends ActiveMessageState {
  GetDoneMessageState({
    required super.messages,
    required super.messageBeingEdited,
    required super.isOver,
  });
}
