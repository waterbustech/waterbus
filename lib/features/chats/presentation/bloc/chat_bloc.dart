import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus/core/utils/modal/show_snackbar.dart';
import 'package:waterbus/features/chats/presentation/widgets/invited_success_text.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/models/chat_status_enum.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/widgets/bottom_sheet_delete.dart';
import 'package:waterbus/features/conversation/bloc/message_bloc.dart';
import 'package:waterbus/features/home/bloc/home/home_bloc.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting_model_x.dart';

part 'chat_event.dart';
part 'chat_state.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final List<Meeting> _conversations = [];
  final WaterbusSdk _waterbusSdk = WaterbusSdk.instance;
  Meeting? _conversationCurrent;
  bool _isOver = false;

  ChatBloc() : super(ChatInitial()) {
    on<ChatEvent>((event, emit) async {
      if (event is OnChatEvent) {
        await _getConversationList();
        emit(_getDoneChat);
      }

      if (event is SelectConversationCurrentEvent) {
        _conversationCurrent = event.meeting;

        emit(_getDoneChat);
      }

      if (event is CleanConversationCurrentEvent) {
        _cleanConversationCurrent();

        emit(_getDoneChat);
      }

      if (event is GetConversationsEvent) {
        if (state is GettingChatState || _isOver) return;

        emit(_gettingChat);
        await _getConversationList();
        emit(_getDoneChat);
      }

      if (event is RefreshConversationsEvent) {
        _cleanChat();
        AppBloc.messageBloc.add(CleanMessageEvent());

        await _getConversationList();
        emit(_getDoneChat);
        event.handleFinish();
      }

      if (event is CreateConversationEvent) {
        final Meeting? meeting = await _createConversation(event);

        if (meeting != null) {
          _conversations.insert(0, meeting);

          emit(_getDoneChat);

          if (AppBloc.homeBloc.currentIndex != 1) {
            AppNavigator.popUntil(Routes.rootRoute);
            AppBloc.homeBloc.add(OnChangeTabEvent(tabIndex: 1));
          } else {
            AppNavigator.popUntil(Routes.rootRoute);
          }

          showSnackBarWaterbus(content: Strings.addConversationSuccess.i18n);
        }
      }

      if (event is AddMemberEvent) {
        final Meeting? meeting =
            await _waterbusSdk.addMember(event.code, event.user.id);

        if (meeting != null) {
          final int index = _conversations
              .indexWhere((conversation) => conversation.id == meeting.id);

          if (index != -1) {
            _conversations[index] = meeting;
          }

          showSnackBarWaterbus(
            child: InvitedSuccessText(
              meeting: meeting,
              fullname: event.user.fullName,
            ),
          );
        }

        emit(_getDoneChat);
      }

      if (event is InsertConversationEvent) {
        _conversations.insert(0, event.conversation);

        emit(_getDoneChat);
      }

      if (event is DeleteMemberEvent) {
        await _handleDeleteMember(event);

        emit(_getDoneChat);
      }

      if (event is DeleteOrLeaveConversationEvent) {
        final Meeting meeting = event.meeting;

        if (meeting.isHost && meeting.members.length > 1) {
          showSnackBarWaterbus(
            content: Strings.hostCanNotDeleteConversation.i18n,
          );
        } else {
          await showModalBottomSheet(
            context: AppNavigator.context!,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            barrierColor: Colors.black38,
            enableDrag: false,
            builder: (context) {
              return BottomSheetDelete(
                actionText:
                    meeting.isHost ? null : Strings.leaveTheConversation.i18n,
                description:
                    meeting.isHost ? null : Strings.sureLeaveConversation.i18n,
                handlePressed: () async {
                  if (meeting.isHost) {
                    add(DeleteConversationByHostEvent(meetingId: meeting.id));
                  } else {
                    add(LeaveConversationByMemberEvent(meeting: meeting));
                  }

                  AppNavigator.popUntil(Routes.rootRoute);
                },
              );
            },
          );
        }
      }

      if (event is LeaveConversationByMemberEvent) {
        await _leaveConversation(event.meeting);

        emit(_getDoneChat);
      }

      if (event is DeleteConversationByHostEvent) {
        await _deleteConversation(event.meetingId);

        emit(_getDoneChat);
      }

      if (event is UpdateLastMessageEvent) {
        _updateLastMessage(event);

        emit(_getDoneChat);
      }

      if (event is CleanChatEvent) {
        _cleanChat();

        emit(_getDoneChat);
      }
    });
  }

  // MARK: state
  GettingChatState get _gettingChat => GettingChatState(
        conversations: _arrangedConversations,
        conversationCurrent: _conversationCurrent,
      );
  GetDoneChatState get _getDoneChat => GetDoneChatState(
        conversations: _arrangedConversations,
        conversationCurrent: _conversationCurrent,
      );

  List<Meeting> get _arrangedConversations {
    _conversations
        .sort((before, after) => after.updatedAt.compareTo(before.updatedAt));

    return _conversations;
  }

  // MARK: private methods
  Future<Meeting?> _createConversation(
    CreateConversationEvent event,
  ) async {
    final Meeting? meeting = await _waterbusSdk.createRoom(
      meeting: Meeting(title: event.title),
      password: event.password,
      userId: AppBloc.userBloc.user?.id,
    );

    return meeting;
  }

  void _updateLastMessage(UpdateLastMessageEvent event) {
    final int index = _conversations.indexWhere(
      (conversation) => conversation.id == event.message.meeting,
    );

    if (index != -1) {
      _conversations[index].latestMessage = event.message;
    }
  }

  Future<void> _deleteConversation(int meetingId) async {
    final bool isSuccess = await _waterbusSdk.deleteConversation(meetingId);

    if (isSuccess) {
      _conversations.removeWhere(
        (conversation) => conversation.id == meetingId,
      );

      if (_conversationCurrent?.id == meetingId) {
        _cleanConversationCurrent();
      }
    }
  }

  Future<void> _leaveConversation(Meeting meeting) async {
    final Meeting? conversation =
        await _waterbusSdk.leaveConversation(meeting.code);

    if (conversation != null) {
      _conversations.removeWhere(
        (conversation) => conversation.id == conversation.id,
      );

      if (_conversationCurrent?.id == conversation.id) {
        _cleanConversationCurrent();
      }
    }
  }

  Future<void> _getConversationList() async {
    final List<Meeting> result = await _waterbusSdk.getConversations(
      skip: _conversations.length,
      status: ChatStatusEnum.join.status,
    );

    _conversations.addAll(result);

    if (result.length < 10) {
      _isOver = true;
    }
  }

  Future<void> _handleDeleteMember(DeleteMemberEvent event) async {
    final Meeting? meeting =
        await _waterbusSdk.deleteMember(event.code, event.userId);

    if (meeting != null) {
      final int index = _conversations
          .indexWhere((conversation) => conversation.code == meeting.code);

      if (index != -1) {
        _conversations[index] = meeting;
      }
    }
  }

  void _cleanChat() {
    _conversations.clear();
    _isOver = false;
    _conversationCurrent = null;
  }

  void _cleanConversationCurrent() {
    _conversationCurrent = null;
  }
}
