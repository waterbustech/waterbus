import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:toastification/toastification.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/types/extensions/failure_x.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/conversation/xmodels/string_extension.dart';

part 'message_event.dart';
part 'message_state.dart';

class CachedMessageByRoomId {
  List<Message> messages;
  bool isOver;

  CachedMessageByRoomId({required this.messages, this.isOver = false});
}

@injectable
class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final Map<int, CachedMessageByRoomId> _messagesMap = {};
  final WaterbusSdk _waterbusSdk = WaterbusSdk.instance;
  int? _meetingId;
  Message? _messageBeingEdited;

  MessageBloc() : super(MessageInitial()) {
    on<MessageEvent>((event, emit) async {
      if (event is MessageSocketStarted) {
        _waterbusSdk.onMessageSocketChanged = _listenMessageSocket;
      }

      if (event is MessageFetchedByMeeting) {
        AppBloc.chatBloc.add(
          ChatCurrentConversationSelected(
            roomId: event.roomId,
          ),
        );

        final CachedMessageByRoomId? cachedMessageByMeetingId =
            _messagesMap[event.roomId];

        if (_meetingId == event.roomId) return;

        _messageBeingEdited = null;
        _meetingId = event.roomId;

        if (cachedMessageByMeetingId == null ||
            (cachedMessageByMeetingId.messages.isEmpty &&
                !cachedMessageByMeetingId.isOver)) {
          emit(MessageInitial());

          _messagesMap[event.roomId] = CachedMessageByRoomId(messages: []);

          await _getMessagesByRoomId(event.roomId);
        }

        emit(_messageDone);
      }

      if (event is MessageFetched) {
        if (state is MessageInProgress ||
            _meetingId == null ||
            _messagesMap[_meetingId]!.isOver) {
          return;
        }

        emit(_messageInProgress);
        await _getMessagesByRoomId(_meetingId!);
        emit(_messageDone);
      }

      if (event is MessageSent) {
        final Message message = Message(
          id: DateTime.now().millisecondsSinceEpoch,
          createdBy: AppBloc.userBloc.user,
          data: event.data,
          status: MessageStatusEnum.active,
          sendingStatus: SendingStatusEnum.sending,
          roomId: event.roomId,
          type: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        _handleInsertMessage(message);

        emit(_messageDone);

        await _sendMessage(message);

        emit(_messageDone);
      }

      if (event is MessageResent) {
        final Message messageModel = event.messageModel
            .copyWith(sendingStatus: SendingStatusEnum.sending);

        final int index = _messagesByMeetingId
            .indexWhere((message) => message.id == messageModel.id);

        if (index != -1) {
          _messagesByMeetingId[index] = _messagesByMeetingId[index]
              .copyWith
              .call(status: messageModel.status);
        }

        emit(_messageDone);

        await _sendMessage(messageModel);

        emit(_messageDone);
      }

      if (event is MessageSelected) {
        _messageBeingEdited = event.message;

        emit(_messageDone);
      }

      if (event is MessageEdited) {
        await _editMessage(event);

        emit(_messageDone);
      }

      if (event is MessageDeleted) {
        await _deleteMessage(event);

        emit(_messageDone);
      }

      if (event is MessageCleaned) {
        _clearMessages();

        emit(_messageDone);
      }

      if (event is MessageEditingCancelled) {
        _messageBeingEdited = null;

        emit(_messageDone);
      }

      if (event is MessageInserted) {
        final CachedMessageByRoomId? cachedMessageByMeetingId =
            _messagesMap[event.message.roomId];

        if (cachedMessageByMeetingId == null) {
          AppBloc.chatBloc
              .add(ChatLatestMessageUpdated(message: event.message));
        } else {
          final int index = cachedMessageByMeetingId.messages
              .indexWhere((message) => message.id == event.message.id);

          if (index == -1) {
            _handleInsertMessage(event.message);
          }

          emit(_messageDone);
        }
      }

      if (event is MessageUpdatedViaSocket) {
        if (event.isDeleted) {
          _handleDeleteMessage(messageModel: event.messageModel);
        } else {
          _handleEditMessage(messageModel: event.messageModel);
        }

        emit(_messageDone);
      }
    });
  }

  // MARK: state
  MessageInProgress get _messageInProgress => MessageInProgress(
        messages: _messagesByMeetingId,
        messageBeingEdited: _messageBeingEdited,
        isOver: _messagesMap[_meetingId]?.isOver ?? false,
      );

  MessageDone get _messageDone => MessageDone(
        messages: _messagesByMeetingId,
        messageBeingEdited: _messageBeingEdited,
        isOver: _messagesMap[_meetingId]?.isOver ?? false,
      );

  List<Message> get _messagesByMeetingId {
    return _messagesMap[_meetingId]?.messages ?? [];
  }

  void _listenMessageSocket(MessageSocketEvent messageSocketEvent) {
    final Message message = messageSocketEvent.message;

    if (message.createdBy?.id == AppBloc.userBloc.user?.id) return;

    if (messageSocketEvent.event == MessageEventEnum.create) {
      add(MessageInserted(message: message));
    } else if (messageSocketEvent.event == MessageEventEnum.update) {
      add(MessageUpdatedViaSocket(messageModel: message));
    } else {
      add(MessageUpdatedViaSocket(messageModel: message, isDeleted: true));
    }
  }

  Future<void> _getMessagesByRoomId(int roomId) async {
    final Result<List<Message>> result = await _waterbusSdk.getMessages(
      roomId: roomId,
      skip: _messagesMap[roomId]?.messages.length ?? 0,
      limit: defaultLengthOfMessages,
    );

    if (result.isSuccess) {
      final List<Message> messagesReponse = result.value ?? [];
      _messagesMap[roomId]?.messages.addAll(messagesReponse);

      if (messagesReponse.length < defaultLengthOfMessages) {
        _messagesMap[_meetingId]?.isOver = true;
      }
    } else {
      result.error.messageException.showToast(ToastificationType.error);
    }
  }

  Future<void> _sendMessage(Message messageModel) async {
    final Result<Message?> result = await _waterbusSdk.sendMessage(
      roomId: messageModel.roomId ?? 0,
      data: messageModel.data,
    );

    if (result.isSuccess) {
      final Message? message = result.value;

      final int index = _messagesByMeetingId
          .indexWhere((message) => message.id == messageModel.id);

      if (index != -1) {
        if (message != null) {
          _messagesByMeetingId[index] = message;

          AppBloc.chatBloc.add(
            ChatLatestMessageUpdated(message: message),
          );
        } else {
          _messagesByMeetingId[index] = _messagesByMeetingId[index]
              .copyWith(sendingStatus: SendingStatusEnum.error);
        }
      }
    } else {
      result.error.messageException.showToast(ToastificationType.error);
    }
  }

  void _handleInsertMessage(Message message) {
    if (_messagesMap[message.roomId] != null) {
      _messagesMap[message.roomId]?.messages.insert(0, message);
    }

    AppBloc.chatBloc.add(ChatLatestMessageUpdated(message: message));
  }

  Future<void> _editMessage(MessageEdited event) async {
    final Result<Message> result = await _waterbusSdk.editMessage(
      data: event.data,
      messageId: event.messageId,
    );

    if (result.isSuccess) {
      final Message? messageModel = result.value;

      if (messageModel != null) {
        _handleEditMessage(messageModel: messageModel);
      }

      _messageBeingEdited = null;
    } else {
      result.error.messageException.showToast(ToastificationType.error);
    }
  }

  void _handleEditMessage({required Message messageModel}) {
    final CachedMessageByRoomId? cachedMessageByRoomId =
        _messagesMap[messageModel.roomId];

    if (cachedMessageByRoomId != null) {
      final int index = cachedMessageByRoomId.messages
          .indexWhere((message) => message.id == messageModel.id);

      if (index != -1) {
        _messagesMap[messageModel.roomId]?.messages[index] =
            cachedMessageByRoomId.messages[index]
                .copyWith(data: messageModel.data);
      }
    }

    AppBloc.chatBloc.add(
      ChatLatestMessageUpdated(message: messageModel, isUpdateMessage: true),
    );
  }

  Future<void> _deleteMessage(MessageDeleted event) async {
    final Result<Message?> result = await _waterbusSdk.deleteMessage(
      messageId: event.messageId,
    );

    if (result.isSuccess) {
      final Message? messageModel = result.value;

      if (messageModel != null) {
        _handleDeleteMessage(messageModel: messageModel);
      }
    } else {
      result.error.messageException.showToast(ToastificationType.error);
    }
  }

  void _handleDeleteMessage({required Message messageModel}) {
    final CachedMessageByRoomId? cachedMessageByMeetingId =
        _messagesMap[messageModel.roomId];

    if (cachedMessageByMeetingId != null) {
      final int index = cachedMessageByMeetingId.messages
          .indexWhere((message) => message.id == messageModel.id);

      if (index != -1) {
        _messagesMap[messageModel.roomId]!.messages[index] =
            cachedMessageByMeetingId.messages[index]
                .copyWith(status: MessageStatusEnum.inactive);
      }
    }

    AppBloc.chatBloc.add(
      ChatLatestMessageUpdated(message: messageModel, isUpdateMessage: true),
    );
  }

  _clearMessages({List<int>? meetingIds}) {
    if (meetingIds == null || meetingIds.isEmpty) {
      _messagesMap.clear();
    } else {
      for (final meetingId in meetingIds) {
        _messagesMap.removeWhere((key, value) => key == meetingId);
      }
    }

    _meetingId = null;
  }
}
