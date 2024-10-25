import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/models/message_status_enum.dart';
import 'package:waterbus_sdk/types/models/sending_status_enum.dart';

import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';

part 'message_event.dart';
part 'message_state.dart';

class CachedMessageByMeetingId {
  List<MessageModel> messages;
  bool isOver;

  CachedMessageByMeetingId({required this.messages, this.isOver = false});
}

@injectable
class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final Map<int, CachedMessageByMeetingId> _messagesMap = {};
  final WaterbusSdk _waterbusSdk = WaterbusSdk.instance;
  int? _meetingId;
  MessageModel? _messageBeingEdited;

  MessageBloc() : super(MessageInitial()) {
    on<MessageEvent>((event, emit) async {
      if (event is InitialMessageSocketEvent) {
        _waterbusSdk.onMessageSocketChanged = _listenMessageSocket;
      }

      if (event is GetMessageByMeetingIdEvent) {
        AppBloc.chatBloc.add(
          SelectConversationCurrentEvent(meetingId: event.meetingId),
        );

        final CachedMessageByMeetingId? cachedMessageByMeetingId =
            _messagesMap[event.meetingId];

        if (_meetingId == event.meetingId) return;

        _messageBeingEdited = null;
        _meetingId = event.meetingId;

        if (cachedMessageByMeetingId == null ||
            (cachedMessageByMeetingId.messages.isEmpty &&
                !cachedMessageByMeetingId.isOver)) {
          emit(MessageInitial());

          _messagesMap[event.meetingId] =
              CachedMessageByMeetingId(messages: []);

          await _getMessagesByMeetingId(event.meetingId);
        }

        emit(_getDoneMessage);
      }

      if (event is GetMoreMessageEvent) {
        if (state is GettingMessageState ||
            _meetingId == null ||
            _messagesMap[_meetingId]!.isOver) {
          return;
        }

        emit(_gettingMessage);
        await _getMessagesByMeetingId(_meetingId!);
        emit(_getDoneMessage);
      }

      if (event is SendMessageEvent) {
        final MessageModel message = MessageModel(
          id: DateTime.now().millisecondsSinceEpoch,
          createdBy: AppBloc.userBloc.user,
          data: event.data,
          status: MessageStatusEnum.active,
          sendingStatus: SendingStatusEnum.sending,
          meeting: event.meetingId,
          type: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        _handleInsertMessage(message);

        emit(_getDoneMessage);

        await _sendMessage(message);

        emit(_getDoneMessage);
      }

      if (event is ResendMessageEvent) {
        final MessageModel messageModel = event.messageModel
            .copyWith(sendingStatus: SendingStatusEnum.sending);

        final int index = _messagesByMeetingId
            .indexWhere((message) => message.id == messageModel.id);

        if (index != -1) {
          _messagesByMeetingId[index].status = messageModel.status;
        }

        emit(_getDoneMessage);

        await _sendMessage(messageModel);

        emit(_getDoneMessage);
      }

      if (event is SelectMessageEditEvent) {
        _messageBeingEdited = event.message;

        emit(_getDoneMessage);
      }

      if (event is EditMessageEvent) {
        await _editMessage(event);

        emit(_getDoneMessage);
      }

      if (event is DeleteMessageEvent) {
        await _deleteMessage(event);

        emit(_getDoneMessage);
      }

      if (event is CleanMessageEvent) {
        _clearMessages();

        emit(_getDoneMessage);
      }

      if (event is CancelEditMessageEvent) {
        _messageBeingEdited = null;

        emit(_getDoneMessage);
      }

      if (event is InsertMessageEvent) {
        final CachedMessageByMeetingId? cachedMessageByMeetingId =
            _messagesMap[event.message.meeting];

        if (cachedMessageByMeetingId == null) {
          AppBloc.chatBloc.add(UpdateLastMessageEvent(message: event.message));
        } else {
          final int index = cachedMessageByMeetingId.messages
              .indexWhere((message) => message.id == event.message.id);

          if (index == -1) {
            _handleInsertMessage(event.message);
          }

          emit(_getDoneMessage);
        }
      }

      if (event is UpdateMessageFromSocketEvent) {
        if (event.isDeleted) {
          _handleDeleteMessage(messageModel: event.messageModel);
        } else {
          _handleEditMessage(messageModel: event.messageModel);
        }

        emit(_getDoneMessage);
      }
    });
  }

  // MARK: state
  GettingMessageState get _gettingMessage => GettingMessageState(
        messages: _messagesByMeetingId,
        messageBeingEdited: _messageBeingEdited,
        isOver: _messagesMap[_meetingId]?.isOver ?? false,
      );

  GetDoneMessageState get _getDoneMessage => GetDoneMessageState(
        messages: _messagesByMeetingId,
        messageBeingEdited: _messageBeingEdited,
        isOver: _messagesMap[_meetingId]?.isOver ?? false,
      );

  List<MessageModel> get _messagesByMeetingId {
    return _messagesMap[_meetingId]?.messages ?? [];
  }

  void _listenMessageSocket(MessageSocketEvent messageSocketEvent) {
    final MessageModel message = messageSocketEvent.message;

    if (message.createdBy?.id == AppBloc.userBloc.user?.id) return;

    if (messageSocketEvent.event == MessageEventEnum.create) {
      add(InsertMessageEvent(message: message));
    } else if (messageSocketEvent.event == MessageEventEnum.update) {
      add(UpdateMessageFromSocketEvent(messageModel: message));
    } else {
      add(UpdateMessageFromSocketEvent(messageModel: message, isDeleted: true));
    }
  }

  Future<void> _getMessagesByMeetingId(int meetingId) async {
    final List<MessageModel> response = await _waterbusSdk.getMessageByRoom(
      meetingId: meetingId,
      skip: _messagesMap[meetingId]?.messages.length ?? 0,
      limit: defaultLengthOfMessages,
    );

    _messagesMap[meetingId]?.messages.addAll(response);

    if (response.length < defaultLengthOfMessages) {
      _messagesMap[_meetingId]?.isOver = true;
    }
  }

  Future<void> _sendMessage(MessageModel messageModel) async {
    final MessageModel? message = await _waterbusSdk.sendMessage(
      meetingId: messageModel.meeting,
      data: messageModel.data,
    );

    final int index = _messagesByMeetingId
        .indexWhere((message) => message.id == messageModel.id);

    if (index != -1) {
      if (message != null) {
        _messagesByMeetingId[index] = message;

        AppBloc.chatBloc.add(
          UpdateLastMessageEvent(message: message),
        );
      } else {
        _messagesByMeetingId[index].sendingStatus = SendingStatusEnum.error;
      }
    }
  }

  void _handleInsertMessage(MessageModel message) {
    if (_messagesMap[message.meeting] != null) {
      _messagesMap[message.meeting]?.messages.insert(0, message);
    }

    AppBloc.chatBloc.add(UpdateLastMessageEvent(message: message));
  }

  Future<void> _editMessage(EditMessageEvent event) async {
    final MessageModel? messageModel = await _waterbusSdk.editMessage(
      data: event.data,
      messageId: event.messageId,
    );

    if (messageModel != null) {
      _handleEditMessage(messageModel: messageModel);
    }

    _messageBeingEdited = null;
  }

  void _handleEditMessage({required MessageModel messageModel}) {
    if (_messagesMap[messageModel.meeting] != null) {
      final int index = _messagesMap[messageModel.meeting]!
          .messages
          .indexWhere((message) => message.id == messageModel.id);

      if (index != -1) {
        _messagesMap[messageModel.meeting]?.messages[index].data =
            messageModel.data;
      }
    }

    AppBloc.chatBloc.add(
      UpdateLastMessageEvent(message: messageModel, isUpdateMessage: true),
    );
  }

  Future<void> _deleteMessage(DeleteMessageEvent event) async {
    final MessageModel? messageModel = await _waterbusSdk.deleteMessage(
      messageId: event.messageId,
    );

    if (messageModel != null) {
      _handleDeleteMessage(messageModel: messageModel);
    }
  }

  void _handleDeleteMessage({required MessageModel messageModel}) {
    if (_messagesMap[messageModel.meeting] != null) {
      final int index = _messagesMap[messageModel.meeting]!
          .messages
          .indexWhere((message) => message.id == messageModel.id);

      if (index != -1) {
        _messagesMap[messageModel.meeting]!.messages[index].status =
            MessageStatusEnum.inactive;
      }
    }

    AppBloc.chatBloc.add(
      UpdateLastMessageEvent(message: messageModel, isUpdateMessage: true),
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
