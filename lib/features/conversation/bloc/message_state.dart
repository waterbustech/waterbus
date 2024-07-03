part of 'message_bloc.dart';

abstract class MessageState {}

class MessageInitial extends MessageState {}

class ActiveMessageState extends MessageState {
  final List<MessageModel> messages;
  final MessageModel? messageBeingEdited;

  ActiveMessageState({
    required this.messages,
    required this.messageBeingEdited,
  });
}

class GettingMessageState extends ActiveMessageState {
  GettingMessageState({
    required super.messages,
    required super.messageBeingEdited,
  });
}

class GetDoneMessageState extends ActiveMessageState {
  GetDoneMessageState({
    required super.messages,
    required super.messageBeingEdited,
  });
}
