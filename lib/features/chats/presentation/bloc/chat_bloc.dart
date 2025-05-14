import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/types/extensions/failure_x.dart';
import 'package:waterbus/core/utils/modal/show_bottom_sheet.dart';
import 'package:waterbus/core/utils/modal/show_snackbar.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/archived/presentation/bloc/archived_bloc.dart';
import 'package:waterbus/features/chats/presentation/widgets/bottom_sheet_delete.dart';
import 'package:waterbus/features/chats/presentation/widgets/invited_success_text.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/conversation/bloc/message_bloc.dart';
import 'package:waterbus/features/conversation/xmodels/string_extension.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting_model_x.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extension.dart';

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
          emit(_chatDone);
        }

        if (SizerUtil.isDesktop) {
          Future.delayed(1.seconds, () {
            if (_conversationCurrent == null && _conversations.isNotEmpty) {
              add(
                ChatCurrentConversationSelected(
                  meeting: _conversations.first,
                ),
              );
            }
          });
        }
      }

      if (event is ChatCurrentConversationSelected) {
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

      if (event is ChatCurrentConversationCleaned) {
        _conversationCurrent = null;

        emit(_chatDone);
      }

      if (event is ChatFetched) {
        if (state is ChatInProgress || _isOver) return;

        emit(_chatInProgress);
        await _getConversationList();
        emit(_chatDone);
      }

      if (event is ChatRefreshed) {
        AppBloc.messageBloc.add(
          MessageCleaned(
            meetingIds:
                _conversations.map((conversation) => conversation.id).toList(),
          ),
        );
        _cleanChat();

        await _getConversationList();
        emit(_chatDone);
        event.handleFinish();
      }

      if (event is ChatCreated) {
        final Meeting? meeting = await _createConversation(event);

        if (meeting != null) {
          _conversations.insert(0, meeting);

          emit(_chatDone);

          AppNavigator.popUntil(Routes.rootRoute);

          Strings.addConversationSuccess.i18n
              .showToast(ToastificationType.success);
        }
      }

      if (event is ChatMemberAdded) {
        final Result<Meeting> response =
            await _waterbusSdk.addMember(event.code, event.user.id);

        if (response.isSuccess) {
          final Meeting? meeting = response.value;

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
        }

        emit(_chatDone);
      }

      if (event is ChatInserted) {
        _conversations.insert(0, event.conversation);

        emit(_chatDone);
      }

      if (event is ChatMemberDeleted) {
        await _handleDeleteMember(event);

        emit(_chatDone);
      }

      if (event is ChatLeft) {
        final Meeting? meeting = event.meeting ?? _conversationCurrent;

        if (meeting == null) return;

        if (meeting.isHost && meeting.members.length > 1) {
          Strings.hostCanNotDeleteConversation.i18n
              .showToast(ToastificationType.error);
        } else {
          await _showBottomSheetSureAction(
            actionText: Strings.leaveTheConversation.i18n,
            description: Strings.sureLeaveConversation.i18n,
            handleAction: () async {
              await _leaveConversation(meeting);

              AppNavigator.popUntil(Routes.rootRoute);

              add(ChatSocketConversationUpdated());
            },
          );
        }
      }

      if (event is ChatDeleted) {
        final Meeting? meeting = event.meeting ?? _conversationCurrent;

        if (meeting == null) return;

        await _showBottomSheetSureAction(
          actionText: Strings.delete.i18n,
          description: Strings.sureDeleteConversation.i18n,
          handleAction: () async {
            await _deleteConversation(meeting);

            AppNavigator.popUntil(Routes.rootRoute);

            add(ChatSocketConversationUpdated());
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

            add(ChatSocketConversationUpdated());
          },
        );
      }

      if (event is ChatUpdated) {
        await _handleUpdateConversation(
          title: event.title,
          password: event.password,
        );
        AppNavigator.pop();
        emit(_chatDone);
      }

      if (event is ChatLatestMessageUpdated) {
        _updateLastMessage(event);

        emit(_chatDone);
      }

      if (event is ChatCleaned) {
        _cleanChat();

        emit(_chatDone);
      }

      if (event is ChatAvatarUpdated) {
        displayLoadingLayer();

        final Result<String> presignedUrl =
            await WaterbusSdk().getPresignedUrl();

        if (presignedUrl.isSuccess) {
          final Result<String> uploadAvatar = await WaterbusSdk().uploadAvatar(
            uploadUrl: presignedUrl.value ?? "",
            image: event.avatar,
          );

          if (uploadAvatar.isSuccess) {
            await _handleUpdateConversation(avatar: uploadAvatar.value);

            emit(_chatDone);
          } else {
            Strings.uploadImageFail.i18n.showToast(ToastificationType.error);
          }
        } else {
          Strings.uploadImageFail.i18n.showToast(ToastificationType.error);
        }

        AppNavigator.pop();
      }

      if (event is ChatSocketConversationUpdated) {
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
    ChatCreated event,
  ) async {
    final Result<Meeting> result = await _waterbusSdk.createRoom(
      meeting: Meeting(title: event.title),
      password: event.password,
      userId: AppBloc.userBloc.user?.id,
    );
    if (result.isSuccess) {
      return result.value;
    } else {
      result.error.messageException.showToast(ToastificationType.error);
      return null;
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
      title: title ?? _conversationCurrent?.title ?? "",
    );

    final Result<bool> result = await _waterbusSdk.updateConversation(
      meeting: meeting,
      password: password,
    );

    if (result.isSuccess) {
      final int index = _conversations.indexWhere(
        (conversation) => conversation.id == meeting.id,
      );

      if (index != -1) {
        _conversationCurrent = _conversations[index] = meeting;
      }

      if (password != null) {
        AppNavigator.pop();
      }

      Strings.chatUpdatedSuccessfully.i18n
          .showToast(ToastificationType.success);
    } else {
      result.error.messageException.showToast(ToastificationType.error);
    }
  }

  void _updateLastMessage(ChatLatestMessageUpdated event) {
    final int index = _conversations.indexWhere(
      (conversation) => conversation.id == event.message.meeting,
    );

    if (index != -1) {
      if (event.isUpdateMessage &&
          _conversations[index].latestMessage?.id != event.message.id) {
        return;
      }

      _conversations[index] =
          _conversations[index].copyWith(latestMessage: event.message);
    }
  }

  Future<void> _deleteConversation(Meeting meeting) async {
    final Result<bool> result =
        await _waterbusSdk.deleteConversation(meeting.id);

    if (result.isSuccess) {
      _cleanConversationCurrent(meeting.id);

      Strings.haveSuccessfullyDeletedConversation.i18n
          .showToast(ToastificationType.success);
    } else {
      result.error.messageException.showToast(ToastificationType.error);
    }
  }

  Future<void> _archivedConversation(Meeting meeting) async {
    final Result<Meeting> result =
        await _waterbusSdk.archivedConversation(meeting.code);

    if (result.isSuccess) {
      final Meeting? archivedConversation = result.value;

      if (archivedConversation != null) {
        AppBloc.archivedBloc.add(
          ArchivedInserted(meeting: archivedConversation),
        );

        _cleanConversationCurrent(archivedConversation.id);

        Strings.haveArchivedConversation.i18n
            .showToast(ToastificationType.success);
      } else {
        Strings.cannotBeArchived.i18n.showToast(ToastificationType.error);
      }
    } else {
      result.error.messageException.showToast(ToastificationType.error);
    }
  }

  Future<void> _leaveConversation(Meeting meeting) async {
    final Result<Meeting> result =
        await _waterbusSdk.leaveConversation(meeting.code);

    if (result.isSuccess) {
      final Meeting? conversation = result.value;

      if (conversation != null) {
        _cleanConversationCurrent(conversation.id);

        Strings.haveLeftConversation.i18n.showToast(ToastificationType.success);
      } else {
        Strings.leaveFailedConversation.i18n
            .showToast(ToastificationType.error);
      }
    } else {
      result.error.messageException.showToast(ToastificationType.error);
    }
  }

  Future<void> _getConversationList() async {
    final Result<List<Meeting>> result = await _waterbusSdk.getConversations(
      skip: _conversations.length,
      status: MemberStatusEnum.joined.value,
    );

    if (result.isSuccess) {
      final List<Meeting> conversationLst = result.value ?? [];

      _conversations.addAll(conversationLst);

      if (conversationLst.length < 10) {
        _isOver = true;
      }
    } else {
      result.error.messageException.showToast(ToastificationType.error);
    }
  }

  Future<void> _handleDeleteMember(ChatMemberDeleted event) async {
    final Result<Meeting> result =
        await _waterbusSdk.deleteMember(event.code, event.userModel.id);

    if (result.isSuccess) {
      final Meeting? meeting = result.value;

      if (meeting != null) {
        final int index = _conversations
            .indexWhere((conversation) => conversation.code == meeting.code);

        if (index != -1) {
          _conversations[index] = meeting;
        }

        final String successTitle =
            "${Strings.youHaveRemoved.i18n} ${event.userModel.fullName} ${Strings.fromTheChat.i18n}";

        successTitle.showToast(ToastificationType.success);
      } else {
        Strings.cannotDeleteMember.i18n.showToast(ToastificationType.error);
      }
    } else {
      result.error.messageException.showToast(ToastificationType.error);
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
