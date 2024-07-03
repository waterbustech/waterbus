import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

part 'message_event.dart';
part 'message_state.dart';

class CachedMessageByMeetingId {
  List<MessageModel> messages;
  bool isOver;

  CachedMessageByMeetingId({required this.messages, this.isOver = false});
}

@injectable
class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final Map<int, CachedMessageByMeetingId> messagesMap = {};
  final WaterbusSdk _waterbusSdk = WaterbusSdk.instance;
  int? meetingId;
  MessageModel? _messageBeingEdited;

  MessageBloc() : super(MessageInitial()) {
    on<MessageEvent>((event, emit) async {
      if (event is GetMessageByMeetingIdEvent) {
        if (meetingId == event.meetingId) return;

        _messageBeingEdited = null;
        meetingId = event.meetingId;

        if (messagesMap[event.meetingId] == null) {
          messagesMap[event.meetingId] = CachedMessageByMeetingId(messages: []);
        }

        if (state is GettingMessageState ||
            messagesMap[event.meetingId]!.isOver) {
          return;
        }

        emit(_gettingMessage);
        await _getMessagesByMeetingId(event.meetingId);
        emit(_getDoneMessage);
      }

      if (event is RefreshMessagesEvent) {
        if (meetingId == null) return;

        emit(_gettingMessage);
        messagesMap[meetingId!] = CachedMessageByMeetingId(messages: []);
        await _getMessagesByMeetingId(meetingId!);
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
    return messagesMap[meetingId]?.messages ?? [];
  }

  Future<void> _getMessagesByMeetingId(int meetingId) async {
    final List<MessageModel> response = await _waterbusSdk.getMessageByRoom(
      meetingId: meetingId,
      skip: messagesMap[meetingId]?.messages.length ?? 0,
    );

    if (response.isNotEmpty) {
      messagesMap[meetingId]?.messages.addAll(response);
    }
  }

  Future<void> _sendMessage(SendMessageEvent event) async {
    final MessageModel? message = await _waterbusSdk.sendMessage(
      meetingId: event.meetingId,
      data: event.data,
    );

    if (message != null) {
      messagesMap[event.meetingId]?.messages.insert(0, message);

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
      final int index = messagesMap[meetingId]!
          .messages
          .indexWhere((message) => message.id == event.messageId);

      if (index != -1) {
        messagesMap[meetingId]?.messages[index].data = event.data;

        AppBloc.chatBloc.add(
          UpdateLastMessageEvent(
            meetingId: event.messageId,
            message: messagesMap[meetingId]!.messages[index],
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
      messagesMap[meetingId]
          ?.messages
          .removeWhere((message) => message.id == event.messageId);

      AppBloc.chatBloc.add(
        UpdateLastMessageEvent(
          meetingId: event.messageId,
          message: messagesMap[meetingId]!.messages.first,
        ),
      );
    }
  }

  _clearMessages() {
    messagesMap.clear();
  }
}
