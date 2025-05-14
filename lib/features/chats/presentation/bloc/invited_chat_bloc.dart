import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:toastification/toastification.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/types/extensions/failure_x.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/conversation/xmodels/string_extension.dart';

part 'invited_chat_event.dart';
part 'invited_chat_state.dart';

@injectable
class InvitedChatBloc extends Bloc<InvitedChatEvent, InvitedChatState> {
  final List<Meeting> _invitedConversations = [];
  final WaterbusSdk _waterbusSdk = WaterbusSdk.instance;
  bool _isOverInvited = false;

  InvitedChatBloc() : super(InvitedChatInitial()) {
    on<InvitedChatEvent>((event, emit) async {
      if (event is InvitedChatStarted) {
        if (_invitedConversations.isEmpty && !_isOverInvited) {
          emit(InvitedChatInitial());
          await _getInvitedConversationList();
          emit(_invitedChatDone);
        }
      }
      if (event is InvitedChatFetched) {
        if (state is InvitedChatInProgress || _isOverInvited) return;

        emit(_invitedChatInprogress);
        await _getInvitedConversationList();
        emit(_invitedChatDone);
      }

      if (event is InvitedChatRefreshed) {
        _invitedConversations.clear();
        _isOverInvited = false;

        await _getInvitedConversationList();
        emit(_invitedChatDone);
        event.handleFinish();
      }

      if (event is InvitedChatAccepted) {
        final Result<Meeting> result =
            await _waterbusSdk.acceptInvite(event.meetingId);

        if (result.isSuccess) {
          final Meeting? meeting = result.value;

          if (meeting != null) {
            _invitedConversations.removeWhere(
              (conversation) => conversation.id == event.meetingId,
            );
            AppBloc.chatBloc.add(ChatInserted(conversation: meeting));

            Strings.youHaveConfirmedConversation.i18n
                .showToast(ToastificationType.success);

            AppNavigator.pop();

            emit(_invitedChatDone);
          }
        } else {
          result.error.messageException.showToast(ToastificationType.error);
        }
      }

      if (event is InvitedChatInserted) {
        if (!_isOverInvited ||
            (_isOverInvited && _invitedConversations.isEmpty)) {
          final index = _invitedConversations
              .indexWhere((invited) => invited.id == event.invited.id);

          if (index != -1) {
            _invitedConversations[index] = event.invited;
          } else {
            _invitedConversations.insert(0, event.invited);
          }

          emit(_invitedChatDone);
        }
      }

      if (event is InvitedChatCleaned) {
        _cleanInvitedChat();
        emit(_invitedChatDone);
      }
    });
  }

  // MARK: state
  InvitedChatInProgress get _invitedChatInprogress =>
      InvitedChatInProgress(invitedConversations: _invitedConversations);
  InvitedChatDone get _invitedChatDone =>
      InvitedChatDone(invitedConversations: _invitedConversations);

  // MARK: private methods
  Future<void> _getInvitedConversationList() async {
    final Result<List<Meeting>> result = await _waterbusSdk.getConversations(
      skip: _invitedConversations.length,
      status: MemberStatusEnum.inviting.value,
    );

    if (result.isSuccess) {
      final List<Meeting> invitedConversations = result.value ?? [];

      _invitedConversations.addAll(invitedConversations);

      if (invitedConversations.length < 10) {
        _isOverInvited = true;
      }
    }
  }

  void _cleanInvitedChat() {
    _invitedConversations.clear();
    _isOverInvited = false;
  }
}
