part of 'message_bloc.dart';

abstract class MessageEvent {}

class GetMessageByMeetingIdEvent extends MessageEvent {
  final int meetingId;

  GetMessageByMeetingIdEvent({required this.meetingId});
}

class RefreshMessagesEvent extends MessageEvent {
  final Function hanleFinish;

  RefreshMessagesEvent({required this.hanleFinish});
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

class CleanMessageEvent extends MessageEvent {}

class InsertMessageEvent extends MessageEvent {
  final MessageModel message;

  InsertMessageEvent({required this.message});
}

class UpdateMessageFromSocketEvent extends MessageEvent {
  final int messageId;
  final String? data;
  final int meetingId;

  UpdateMessageFromSocketEvent({
    required this.messageId,
    required this.meetingId,
    this.data,
  });
}
