part of 'message_bloc.dart';

abstract class MessageEvent {}

class MessageSocketStarted extends MessageEvent {}

class MessageFetchedByMeeting extends MessageEvent {
  final int meetingId;
  final Function? handleFinish;

  MessageFetchedByMeeting({
    required this.meetingId,
    this.handleFinish,
  });
}

class MessageFetched extends MessageEvent {}

class MessageResent extends MessageEvent {
  final MessageModel messageModel;

  MessageResent({required this.messageModel});
}

class MessageSent extends MessageEvent {
  final String data;
  final int meetingId;

  MessageSent({required this.data, required this.meetingId});
}

class MessageEdited extends MessageEvent {
  final String data;
  final int messageId;

  MessageEdited({required this.data, required this.messageId});
}

class MessageSelected extends MessageEvent {
  final MessageModel message;

  MessageSelected({required this.message});
}

class MessageDeleted extends MessageEvent {
  final int messageId;

  MessageDeleted({required this.messageId});
}

class MessageEditingCancelled extends MessageEvent {}

class MessageCleaned extends MessageEvent {
  final List<int> meetingIds;

  MessageCleaned({required this.meetingIds});
}

class MessageInserted extends MessageEvent {
  final MessageModel message;

  MessageInserted({required this.message});
}

class MessageUpdatedViaSocket extends MessageEvent {
  final MessageModel messageModel;
  final bool isDeleted;

  MessageUpdatedViaSocket({
    required this.messageModel,
    this.isDeleted = false,
  });
}
