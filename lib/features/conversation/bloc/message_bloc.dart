import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

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
      if (event is GetMessageByMeetingIdEvent) {
        if (_meetingId == event.meetingId) return;

        _messageBeingEdited = null;
        _meetingId = event.meetingId;

        if (_messagesMap[event.meetingId] == null) {
          _messagesMap[event.meetingId] =
              CachedMessageByMeetingId(messages: []);
        }

        if (state is GettingMessageState ||
            _messagesMap[event.meetingId]!.isOver) {
          return;
        }

        emit(_gettingMessage);
        await _getMessagesByMeetingId(event.meetingId);
        emit(_getDoneMessage);
      }

      if (event is RefreshMessagesEvent) {
        if (_meetingId == null) return;

        emit(_gettingMessage);
        _messagesMap[_meetingId!] = CachedMessageByMeetingId(messages: []);
        await _getMessagesByMeetingId(_meetingId!);
        emit(_getDoneMessage);
      }

      if (event is SendMessageEvent) {
        await _sendMessage(event);

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
        if (_messagesMap[event.message.meeting] == null) {
          _messagesMap[event.message.meeting] =
              CachedMessageByMeetingId(messages: []);
        }

        final int? index = _messagesMap[event.message.meeting]
            ?.messages
            .indexWhere((message) => message.id == event.message.id);

        if (index == -1) {
          _messagesMap[event.message.meeting]
              ?.messages
              .insert(0, event.message);
        }

        emit(_getDoneMessage);
      }

      if (event is UpdateMessageFromSocketEvent) {
        final int? index = _messagesMap[event.meetingId]
            ?.messages
            .indexWhere((message) => message.id == event.messageId);

        if (index != null && index != -1) {
          if (event.data == null) {
            _messagesMap[event.meetingId]?.messages.removeAt(index);
          } else {
            _messagesMap[event.meetingId]?.messages[index].data =
                event.data ?? "";
          }
        }

        emit(_getDoneMessage);
      }
    });
  }

  // MARK: state
  GettingMessageState get _gettingMessage => GettingMessageState(
        messages: _messagesByMeetingId,
        messageBeingEdited: _messageBeingEdited,
      );

  GetDoneMessageState get _getDoneMessage => GetDoneMessageState(
        messages: _messagesByMeetingId,
        messageBeingEdited: _messageBeingEdited,
      );

  List<MessageModel> get _messagesByMeetingId {
    return _messagesMap[_meetingId]?.messages ?? [];
  }

  Future<void> _getMessagesByMeetingId(int meetingId) async {
    final List<MessageModel> response = await _waterbusSdk.getMessageByRoom(
      meetingId: meetingId,
      skip: _messagesMap[meetingId]?.messages.length ?? 0,
    );

    if (response.isNotEmpty) {
      _messagesMap[meetingId]?.messages.addAll(response);
    }
  }

  Future<void> _sendMessage(SendMessageEvent event) async {
    final MessageModel? message = await _waterbusSdk.sendMessage(
      meetingId: event.meetingId,
      data: event.data,
    );

    if (message != null) {
      _messagesMap[event.meetingId]?.messages.insert(0, message);

      AppBloc.chatBloc.add(
        UpdateLastMessageEvent(
          meetingId: event.meetingId,
          message: message,
        ),
      );
    }
  }

  Future<void> _editMessage(EditMessageEvent event) async {
    final bool isSuccess = await _waterbusSdk.editMessage(
      data: event.data,
      messageId: event.messageId,
    );

    if (isSuccess) {
      final int index = _messagesMap[_meetingId]!
          .messages
          .indexWhere((message) => message.id == event.messageId);

      if (index != -1) {
        _messagesMap[_meetingId]?.messages[index].data = event.data;

        AppBloc.chatBloc.add(
          UpdateLastMessageEvent(
            meetingId: event.messageId,
            message: _messagesMap[_meetingId]!.messages[index],
          ),
        );
      }
    }

    _messageBeingEdited = null;
  }

  Future<void> _deleteMessage(DeleteMessageEvent event) async {
    final bool isSuccess = await _waterbusSdk.deleteMessage(
      messageId: event.messageId,
    );

    if (isSuccess) {
      _messagesMap[_meetingId]
          ?.messages
          .removeWhere((message) => message.id == event.messageId);

      AppBloc.chatBloc.add(
        UpdateLastMessageEvent(
          meetingId: event.messageId,
          message: _messagesMap[_meetingId]!.messages.first,
        ),
      );
    }
  }

  _clearMessages() {
    _messagesMap.clear();
  }
}
