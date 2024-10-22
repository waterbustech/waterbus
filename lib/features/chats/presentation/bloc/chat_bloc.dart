import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/models/chat_status_enum.dart';
import 'package:waterbus_sdk/types/models/conversation_socket_event.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extensions.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/modal/show_snackbar.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/invited_chat_bloc.dart';
import 'package:waterbus/features/chats/presentation/widgets/bottom_sheet_delete.dart';
import 'package:waterbus/features/chats/presentation/widgets/invited_success_text.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/conversation/bloc/message_bloc.dart';
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
        if (_conversations.isEmpty) {
          await _getConversationList();
          _waterbusSdk.onConversationSocketChanged = _listenConversationSocket;
          emit(_getDoneChat);
        }

        if (SizerUtil.isDesktop) {
          Future.delayed(1.seconds, () {
            if (_conversationCurrent == null && _conversations.isNotEmpty) {
              add(
                SelectConversationCurrentEvent(meeting: _conversations.first),
              );
            }
          });
        }
      }

      if (event is SelectConversationCurrentEvent) {
        if (event.meeting != null) {
          _conversationCurrent = event.meeting;
        } else {
          if (event.meetingId == null) return;

          final index = _conversations
              .indexWhere((conversation) => conversation.id == event.meetingId);

          if (index != -1) {
            _conversationCurrent = _conversations[index];
          }
        }

        emit(_getDoneChat);
      }

      if (event is CleanConversationCurrentEvent) {
        _conversationCurrent = null;

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

          AppNavigator.popUntil(Routes.rootRoute);

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

      if (event is ArchivedOrLeaveConversationEvent) {
        final Meeting? current = event.meeting ?? _conversationCurrent;

        if (current == null) return;

        final int index = _conversations
            .indexWhere((conversation) => conversation.id == current.id);

        if (index != -1) {
          final Meeting meeting = _conversations[index];

          if (meeting.isHost && meeting.members.length > 1) {
            showSnackBarWaterbus(
              content: Strings.hostCanNotDeleteConversation.i18n,
            );

            AppNavigator.pop();
          } else {
            await showModalBottomSheet(
              context: AppNavigator.context!,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              barrierColor: Colors.black38,
              enableDrag: false,
              builder: (context) {
                return BottomSheetDelete(
                  actionText: meeting.isHost
                      ? Strings.archivedChats.i18n
                      : Strings.leaveTheConversation.i18n,
                  description: meeting.isHost
                      ? Strings.sureArchivedConversation.i18n
                      : Strings.sureLeaveConversation.i18n,
                  handlePressed: () async {
                    if (meeting.isHost) {
                      add(
                        ChangeConversationToArchivedEvent(
                          meetingId: meeting.id,
                        ),
                      );
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
      }

      if (event is LeaveConversationByMemberEvent) {
        await _leaveConversation(event.meeting);

        emit(_getDoneChat);
      }

      if (event is ChangeConversationToArchivedEvent) {
        await _archivedConversation(event.meetingId);

        emit(_getDoneChat);
      }

      if (event is UpdateConversationEvent) {
        await _handleUpdateConversation(
          title: event.title,
          password: event.password,
        );
        AppNavigator.pop();
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

      if (event is UpdateAvatarConversationEvent) {
        displayLoadingLayer();

        final String? presignedUrl = await WaterbusSdk().getPresignedUrl();

        if (presignedUrl != null) {
          final String? uploadAvatar = await WaterbusSdk().uploadAvatar(
            uploadUrl: presignedUrl,
            image: event.avatar,
          );

          if (uploadAvatar != null) {
            await _handleUpdateConversation(avatar: uploadAvatar);

            emit(_getDoneChat);
          } else {
            showSnackBarWaterbus(content: Strings.uploadImageFail.i18n);
          }
        }

        AppNavigator.pop();
      }

      if (event is UpdateConversationFromSocketEvent) {
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

  void _listenConversationSocket(ConversationSocketEvent socketEvent) {
    final Meeting? newConversation = socketEvent.conversation;
    final Member? newMember = socketEvent.member;

    if (socketEvent.event == ConversationEventEnum.newInvitaion) {
      if (newConversation == null) return;
      AppBloc.invitedChatBloc
          .add(InsertInvitedConversationsEvent(invited: newConversation));
    } else if (socketEvent.event == ConversationEventEnum.newMemberJoined) {
      if (newMember == null) return;

      final int index = _conversations
          .indexWhere((conversation) => conversation.id == newMember.meetingId);

      if (index != -1) {
        final indexMember = _conversations[index]
            .members
            .indexWhere((member) => member.id == newMember.id);
        if (indexMember != -1) {
          _conversations[index].members[indexMember].status =
              MemberStatusEnum.joined;
        }
      }

      add(UpdateConversationFromSocketEvent());
    }
  }

  Future<void> _handleUpdateConversation({
    String? title,
    String? avatar,
    String? password,
  }) async {
    if (_conversationCurrent == null) return;

    final Meeting meeting = _conversationCurrent!.copyWith(
      avatar: avatar ?? _conversationCurrent?.avatar,
      title: title ?? _conversationCurrent?.title,
    );

    final isSuccess = await _waterbusSdk.updateConversation(
      meeting: meeting,
      password: password,
    );

    if (isSuccess) {
      final int index = _conversations.indexWhere(
        (conversation) => conversation.id == meeting.id,
      );

      if (index != -1) {
        _conversationCurrent = _conversations[index] = meeting;
      }

      if (password != null) {
        AppNavigator.pop();
      }

      showSnackBarWaterbus(
        content: Strings.chatUpdatedSuccessfully.i18n,
      );
    } else {
      showSnackBarWaterbus(
        content: Strings.chatUpdateFailed.i18n,
      );
    }
  }

  void _updateLastMessage(UpdateLastMessageEvent event) {
    final int index = _conversations.indexWhere(
      (conversation) => conversation.id == event.message.meeting,
    );

    if (index != -1) {
      if (event.isUpdateMessage &&
          _conversations[index].latestMessage?.id != event.message.id) return;

      _conversations[index].latestMessage = event.message;
    }
  }

  Future<void> _archivedConversation(int meetingId) async {
    final bool isSuccess = await _waterbusSdk.deleteConversation(meetingId);

    if (isSuccess) {
      _cleanConversationCurrent(meetingId);
    }
  }

  Future<void> _leaveConversation(Meeting meeting) async {
    final Meeting? conversation =
        await _waterbusSdk.leaveConversation(meeting.code);

    if (conversation != null) {
      _cleanConversationCurrent(conversation.id);
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

  void _cleanConversationCurrent(int meetingId) {
    _conversations.removeWhere(
      (conversation) => conversation.id == meetingId,
    );

    if (_conversationCurrent?.id == meetingId) {
      if (SizerUtil.isDesktop && _conversations.isNotEmpty) {
        _conversationCurrent = _conversations.first;
      } else {
        _conversationCurrent = null;
      }
    }
  }

  Meeting? get conversationCurrent => _conversationCurrent;
}
