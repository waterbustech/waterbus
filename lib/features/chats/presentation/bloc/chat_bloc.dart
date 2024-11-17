import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/models/conversation_socket_event.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extensions.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/modal/show_bottom_sheet.dart';
import 'package:waterbus/core/utils/modal/show_snackbar.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/archived/presentation/bloc/archived_bloc.dart';
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
      if (event is ChatStarted) {
        if (_conversations.isEmpty) {
          await _getConversationList();
          _waterbusSdk.onConversationSocketChanged = _listenConversationSocket;
          emit(_chatDone);
        }

        if (SizerUtil.isDesktop) {
          Future.delayed(1.seconds, () {
            if (_conversationCurrent == null && _conversations.isNotEmpty) {
              add(
                ChatSelectTheCurrent(meeting: _conversations.first),
              );
            }
          });
        }
      }

      if (event is ChatSelectTheCurrent) {
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

        emit(_chatDone);
      }

      if (event is ChatCleanConversationCurrent) {
        _conversationCurrent = null;

        emit(_chatDone);
      }

      if (event is ChatGet) {
        if (state is ChatInProgress || _isOver) return;

        emit(_chatInProgress);
        await _getConversationList();
        emit(_chatDone);
      }

      if (event is ChatRefresh) {
        AppBloc.messageBloc.add(
          CleanMessageEvent(
            meetingIds:
                _conversations.map((conversation) => conversation.id).toList(),
          ),
        );
        _cleanChat();

        await _getConversationList();
        emit(_chatDone);
        event.handleFinish();
      }

      if (event is ChatCreate) {
        final Meeting? meeting = await _createConversation(event);

        if (meeting != null) {
          _conversations.insert(0, meeting);

          emit(_chatDone);

          AppNavigator.popUntil(Routes.rootRoute);

          showSnackBarWaterbus(content: Strings.addConversationSuccess.i18n);
        }
      }

      if (event is ChatAddMember) {
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

        emit(_chatDone);
      }

      if (event is ChatInsert) {
        _conversations.insert(0, event.conversation);

        emit(_chatDone);
      }

      if (event is ChatDeleteMember) {
        await _handleDeleteMember(event);

        emit(_chatDone);
      }

      if (event is ChatLeave) {
        final Meeting? meeting = event.meeting ?? _conversationCurrent;

        if (meeting == null) return;

        if (meeting.isHost && meeting.members.length > 1) {
          showSnackBarWaterbus(
            content: Strings.hostCanNotDeleteConversation.i18n,
          );
        } else {
          await _showBottomSheetSureAction(
            actionText: Strings.leaveTheConversation.i18n,
            description: Strings.sureLeaveConversation.i18n,
            handleAction: () async {
              await _leaveConversation(meeting);

              AppNavigator.popUntil(Routes.rootRoute);

              add(ChatUpdateConversationFromSocket());
            },
          );
        }
      }

      if (event is ChatDelete) {
        final Meeting? meeting = event.meeting ?? _conversationCurrent;

        if (meeting == null) return;

        await _showBottomSheetSureAction(
          actionText: Strings.delete.i18n,
          description: Strings.sureDeleteConversation.i18n,
          handleAction: () async {
            await _deleteConversation(meeting);

            AppNavigator.popUntil(Routes.rootRoute);

            add(ChatUpdateConversationFromSocket());
          },
        );
      }

      if (event is ChatArchived) {
        final Meeting? meeting = event.meeting ?? _conversationCurrent;

        if (meeting == null) return;

        await _showBottomSheetSureAction(
          actionText: Strings.archivedChats.i18n,
          description: Strings.sureArchivedConversation.i18n,
          handleAction: () async {
            await _archivedConversation(meeting);

            AppNavigator.popUntil(Routes.rootRoute);

            add(ChatUpdateConversationFromSocket());
          },
        );
      }

      if (event is ChatUpdate) {
        await _handleUpdateConversation(
          title: event.title,
          password: event.password,
        );
        AppNavigator.pop();
        emit(_chatDone);
      }

      if (event is ChatUpdateLastMessage) {
        _updateLastMessage(event);

        emit(_chatDone);
      }

      if (event is ChatClean) {
        _cleanChat();

        emit(_chatDone);
      }

      if (event is ChatUpdateAvatar) {
        displayLoadingLayer();

        final String? presignedUrl = await WaterbusSdk().getPresignedUrl();

        if (presignedUrl != null) {
          final String? uploadAvatar = await WaterbusSdk().uploadAvatar(
            uploadUrl: presignedUrl,
            image: event.avatar,
          );

          if (uploadAvatar != null) {
            await _handleUpdateConversation(avatar: uploadAvatar);

            emit(_chatDone);
          } else {
            showSnackBarWaterbus(content: Strings.uploadImageFail.i18n);
          }
        }

        AppNavigator.pop();
      }

      if (event is ChatUpdateConversationFromSocket) {
        emit(_chatDone);
      }
    });
  }

  Future<void> _showBottomSheetSureAction({
    required String actionText,
    required String description,
    required Function() handleAction,
  }) async {
    await showBottomSheetWaterbus(
      context: AppNavigator.context!,
      enableDrag: false,
      builder: (context) {
        return BottomSheetDelete(
          actionText: actionText,
          description: description,
          handlePressed: handleAction,
        );
      },
    );
  }

  // MARK: state
  ChatInProgress get _chatInProgress => ChatInProgress(
        conversations: _arrangedConversations,
        conversationCurrent: _conversationCurrent,
      );

  ChatDone get _chatDone => ChatDone(
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
    ChatCreate event,
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
      AppBloc.invitedChatBloc.add(InvitedChatInsert(invited: newConversation));
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

      add(ChatUpdateConversationFromSocket());
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

  void _updateLastMessage(ChatUpdateLastMessage event) {
    final int index = _conversations.indexWhere(
      (conversation) => conversation.id == event.message.meeting,
    );

    if (index != -1) {
      if (event.isUpdateMessage &&
          _conversations[index].latestMessage?.id != event.message.id) return;

      _conversations[index].latestMessage = event.message;
    }
  }

  Future<void> _deleteConversation(Meeting meeting) async {
    final bool isSuccess = await _waterbusSdk.deleteConversation(meeting.id);

    if (isSuccess) {
      _cleanConversationCurrent(meeting.id);

      showSnackBarWaterbus(
        content: Strings.haveSuccessfullyDeletedConversation.i18n,
      );
    } else {
      showSnackBarWaterbus(content: Strings.cannotDeleteConversation.i18n);
    }
  }

  Future<void> _archivedConversation(Meeting meeting) async {
    final Meeting? archivedConversation =
        await _waterbusSdk.archivedConversation(meeting.code);

    if (archivedConversation != null) {
      AppBloc.archivedBloc.add(
        InsertArchivedEvent(meeting: archivedConversation),
      );

      _cleanConversationCurrent(archivedConversation.id);

      showSnackBarWaterbus(content: Strings.haveArchivedConversation.i18n);
    } else {
      showSnackBarWaterbus(content: Strings.cannotBeArchived.i18n);
    }
  }

  Future<void> _leaveConversation(Meeting meeting) async {
    final Meeting? conversation =
        await _waterbusSdk.leaveConversation(meeting.code);

    if (conversation != null) {
      _cleanConversationCurrent(conversation.id);

      showSnackBarWaterbus(content: Strings.haveLeftConversation.i18n);
    } else {
      showSnackBarWaterbus(content: Strings.leaveFailedConversation.i18n);
    }
  }

  Future<void> _getConversationList() async {
    final List<Meeting> result = await _waterbusSdk.getConversations(
      skip: _conversations.length,
      status: MemberStatusEnum.joined.value,
    );

    _conversations.addAll(result);

    if (result.length < 10) {
      _isOver = true;
    }
  }

  Future<void> _handleDeleteMember(ChatDeleteMember event) async {
    final Meeting? meeting =
        await _waterbusSdk.deleteMember(event.code, event.userModel.id);

    if (meeting != null) {
      final int index = _conversations
          .indexWhere((conversation) => conversation.code == meeting.code);

      if (index != -1) {
        _conversations[index] = meeting;
      }

      showSnackBarWaterbus(
        content:
            "${Strings.youHaveRemoved.i18n} ${event.userModel.fullName} ${Strings.fromTheChat.i18n}",
      );
    } else {
      showSnackBarWaterbus(content: Strings.cannotDeleteMember.i18n);
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
