part of 'message_bloc.dart';

abstract class MessageEvent {}

class MessageSocketStarted extends MessageEvent {}

class MessageGetByMeeting extends MessageEvent {
  final int meetingId;
  final Function? handleFinish;

  MessageGetByMeeting({
    required this.meetingId,
    this.handleFinish,
  });
}

class MessageGetMore extends MessageEvent {}

class MessageResend extends MessageEvent {
  final MessageModel messageModel;

  MessageResend({required this.messageModel});
}

class MessageSend extends MessageEvent {
  final String data;
  final int meetingId;

  MessageSend({required this.data, required this.meetingId});
}

class MessageEdit extends MessageEvent {
  final String data;
  final int messageId;

  MessageEdit({required this.data, required this.messageId});
}

class MessageSelect extends MessageEvent {
  final MessageModel message;

  MessageSelect({required this.message});
}

class MessageDelete extends MessageEvent {
  final int messageId;

  MessageDelete({required this.messageId});
}

class MessageCancelEditing extends MessageEvent {}

class MessageClean extends MessageEvent {
  final List<int> meetingIds;

  MessageClean({required this.meetingIds});
}

class MessageInsert extends MessageEvent {
  final MessageModel message;

  MessageInsert({required this.message});
}

class MessageUpdateFromSocket extends MessageEvent {
  final MessageModel messageModel;
  final bool isDeleted;

  MessageUpdateFromSocket({
    required this.messageModel,
    this.isDeleted = false,
  });
}
