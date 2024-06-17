import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/home/bloc/home/home_bloc.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/models/chat_status_enum.dart';

part 'chat_event.dart';
part 'chat_state.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final List<Meeting> _conversations = [];
  final List<Meeting> _invitedConversations = [];
  final WaterbusSdk _waterbusSdk = WaterbusSdk.instance;
  bool _isOver = false;
  bool _isOverInvited = false;

  ChatBloc() : super(ChatInitial()) {
    on<ChatEvent>((event, emit) async {
      if (event is OnChatEvent) {
        await _getConversationList();
        emit(_getDoneChat);
      }

      if (event is GetConversationsEvent) {
        if (event is GettingChatState || _isOver) return;

        emit(_gettingChat);
        await _getConversationList();
        emit(_getDoneChat);
      }

      if (event is GetInvitedConversations) {
        if (event is GettingInvitedChatState || _isOverInvited) return;

        emit(_gettingInvitedChat);
        await _getConversationList(status: ChatStatusEnum.invite);
        emit(_getDoneChat);
      }

      if (event is CreateConversationEvent) {
        final Meeting? meeting = await _waterbusSdk.createRoom(
          meeting: Meeting(title: event.title),
          password: event.password,
          userId: AppBloc.userBloc.user?.id,
        );

        if (meeting != null) {
          _conversations.add(meeting);

          emit(_getDoneChat);

          if (AppBloc.homeBloc.currentIndex != 1) {
            AppNavigator.popUntil(Routes.rootRoute);
            AppBloc.homeBloc.add(OnChangeTabEvent(tabIndex: 1));
          } else {
            AppNavigator.popUntil(Routes.rootRoute);
          }
        }
      }

      if (event is AddMemberEvent) {
        final bool isSuccess =
            await _waterbusSdk.addMember(event.code, event.userId);

        if (!isSuccess) {}

        emit(_getDoneChat);
      }

      if (event is AcceptInviteEvent) {
        final Meeting? meeting = await _waterbusSdk.acceptInvite(event.code);

        if (meeting != null) {
          _invitedConversations
              .removeWhere((conversation) => conversation.code == event.code);
          _conversations.add(meeting);

          emit(_getDoneChat);
        }
      }

      if (event is DeleteMemberEvent) {
        final Meeting? meeting =
            await _waterbusSdk.deleteMember(event.code, event.userId);

        if (meeting != null) {
          final int index = _conversations
              .indexWhere((conversation) => conversation.code == meeting.code);

          if (index != -1) {
            _conversations[index] = meeting;
          }

          emit(_getDoneChat);
        }
      }

      if (event is DeleteConversationEvent) {
        final bool isSuccess =
            await _waterbusSdk.deleteConversation(event.meetingId);

        if (isSuccess) {
          _conversations.removeWhere(
            (conversation) => conversation.id == event.meetingId,
          );

          emit(_getDoneChat);
        }
      }

      if (event is CleanChatEvent) {
        _cleanChat();

        emit(_getDoneChat);
      }
    });
  }

  // MARK: state
  GettingChatState get _gettingChat => GettingChatState(
        conversations: _conversations,
        invitedConversations: _invitedConversations,
      );
  GetDoneChatState get _getDoneChat => GetDoneChatState(
        conversations: _conversations,
        invitedConversations: _invitedConversations,
      );
  GettingInvitedChatState get _gettingInvitedChat => GettingInvitedChatState(
        conversations: _conversations,
        invitedConversations: _invitedConversations,
      );

  // MARK: private methods
  Future<void> _getConversationList({
    ChatStatusEnum status = ChatStatusEnum.join,
  }) async {
    final List<Meeting> result = await _waterbusSdk.getConversations(
      skip: status == ChatStatusEnum.join
          ? _conversations.length
          : _invitedConversations.length,
      status: status.status,
    );

    if (result.isNotEmpty) {
      if (status == ChatStatusEnum.join) {
        _conversations.addAll(result);

        if (result.length < 10) {
          _isOver = true;
        }
      } else {
        _invitedConversations.addAll(result);

        if (result.length < 10) {
          _isOverInvited = true;
        }
      }
    }
  }

  void _cleanChat() {
    _conversations.clear();
    _invitedConversations.clear();
    _isOver = false;
    _isOverInvited = false;
  }
}
