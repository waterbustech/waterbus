part of 'message_bloc.dart';

abstract class MessageEvent {}

class InitialMessageSocketEvent extends MessageEvent {}

class GetMessageByMeetingIdEvent extends MessageEvent {
  final int meetingId;
  final Function? handleFinish;

  GetMessageByMeetingIdEvent({
    required this.meetingId,
    this.handleFinish,
  });
}

class GetMoreMessageEvent extends MessageEvent {}

class ResendMessageEvent extends MessageEvent {
  final MessageModel messageModel;

  ResendMessageEvent({required this.messageModel});
}

class SendMessageEvent extends MessageEvent {
  final String data;
  final int meetingId;

  SendMessageEvent({required this.data, required this.meetingId});
}

class EditMessageEvent extends MessageEvent {
  final String data;
  final int messageId;

  EditMessageEvent({required this.data, required this.messageId});
}

class SelectMessageEditEvent extends MessageEvent {
  final MessageModel message;

  SelectMessageEditEvent({required this.message});
}

class DeleteMessageEvent extends MessageEvent {
  final int messageId;

  DeleteMessageEvent({required this.messageId});
}

class CancelEditMessageEvent extends MessageEvent {}

class CleanMessageEvent extends MessageEvent {
  final List<int> meetingIds;

  CleanMessageEvent({required this.meetingIds});
}

class InsertMessageEvent extends MessageEvent {
  final MessageModel message;

  InsertMessageEvent({required this.message});
}

class UpdateMessageFromSocketEvent extends MessageEvent {
  final MessageModel messageModel;
  final bool isDeleted;

  UpdateMessageFromSocketEvent({
    required this.messageModel,
    this.isDeleted = false,
  });
}
