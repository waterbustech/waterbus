part of 'message_bloc.dart';

abstract class MessageEvent {}

class MessageSocketStarted extends MessageEvent {}

class MessageFetchedByMeeting extends MessageEvent {
  final int roomId;
  final Function? handleFinish;

  MessageFetchedByMeeting({
    required this.roomId,
    this.handleFinish,
  });
}

class MessageFetched extends MessageEvent {}

class MessageResent extends MessageEvent {
  final Message messageModel;

  MessageResent({required this.messageModel});
}

class MessageSent extends MessageEvent {
  final String data;
  final int roomId;

  MessageSent({required this.data, required this.roomId});
}

class MessageEdited extends MessageEvent {
  final String data;
  final int messageId;

  MessageEdited({required this.data, required this.messageId});
}

class MessageSelected extends MessageEvent {
  final Message message;

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
  final Message message;

  MessageInserted({required this.message});
}

class MessageUpdatedViaSocket extends MessageEvent {
  final Message messageModel;
  final bool isDeleted;

  MessageUpdatedViaSocket({
    required this.messageModel,
    this.isDeleted = false,
  });
}
