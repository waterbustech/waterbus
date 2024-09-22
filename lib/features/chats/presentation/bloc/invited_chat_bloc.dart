import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/models/chat_status_enum.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/utils/modal/show_snackbar.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';

part 'invited_chat_event.dart';
part 'invited_chat_state.dart';

@injectable
class InvitedChatBloc extends Bloc<InvitedChatEvent, InvitedChatState> {
  final List<Meeting> _invitedConversations = [];
  final WaterbusSdk _waterbusSdk = WaterbusSdk.instance;
  bool _isOverInvited = false;

  InvitedChatBloc() : super(InvitedChatInitial()) {
    on<InvitedChatEvent>((event, emit) async {
      if (event is OnInvitedConversationEvent) {
        emit(InvitedChatInitial());
        _invitedConversations.clear();
        _isOverInvited = false;
        await _getInvitedConversationList();
        emit(_getDoneChat);
      }
      if (event is GetInvitedConversationsEvent) {
        if (state is GettingInvitedChatState || _isOverInvited) return;

        emit(_gettingInvitedChat);
        await _getInvitedConversationList();
        emit(_getDoneChat);
      }

      if (event is RefreshInvitedConversationsEvent) {
        _invitedConversations.clear();
        _isOverInvited = false;

        await _getInvitedConversationList();
        emit(_getDoneChat);
        event.handleFinish();
      }

      if (event is AcceptInviteEvent) {
        final Meeting? meeting = await _waterbusSdk.acceptInvite(event.code);

        if (meeting != null) {
          _invitedConversations
              .removeWhere((conversation) => conversation.code == event.code);
          AppBloc.chatBloc.add(InsertConversationEvent(conversation: meeting));

          showSnackBarWaterbus(
            content: Strings.youHaveConfirmedConversation.i18n,
          );

          emit(_getDoneChat);
        }
      }

      if (event is CleanInvitedConversationEvent) {
        _cleanInvitedChat();
        emit(_getDoneChat);
      }
    });
  }

  // MARK: state
  GettingInvitedChatState get _gettingInvitedChat => GettingInvitedChatState(
        invitedConversations: _invitedConversations,
      );
  GetDoneInvitedChatState get _getDoneChat => GetDoneInvitedChatState(
        invitedConversations: _invitedConversations,
      );

  // MARK: private methods
  Future<void> _getInvitedConversationList() async {
    final List<Meeting> result = await _waterbusSdk.getConversations(
      skip: _invitedConversations.length,
      status: ChatStatusEnum.invite.status,
    );

    _invitedConversations.addAll(result);

    if (result.length < 10) {
      _isOverInvited = true;
    }
  }

  void _cleanInvitedChat() {
    _invitedConversations.clear();
    _isOverInvited = false;
  }
}
