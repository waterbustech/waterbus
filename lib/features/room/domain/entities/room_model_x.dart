import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/languages/localization.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/conversation/domain/entities/message_model_x.dart';
import 'package:waterbus/features/conversation/domain/entities/option_model.dart';
import 'package:waterbus/features/settings/data/repositories/language_repository.dart';

extension RoomModelX on Room {
  String get latestMessageData => latestMessage != null
      ? "${latestMessage!.isMe && latestMessage!.status != MessageStatusEnum.inactive ? "${Strings.you.i18n}: " : ""}${latestMessage!.dataX}"
      : Strings.groupCreated.i18n;

  bool get isGroup => memberJoined.length >= 2;

  StatusSeenMessage get statusLastedMessage => StatusSeenMessage.seen;

  List<Member> get memberJoined => members
      .where((member) => member.status == MemberStatusEnum.joined)
      .toList();

  StatusMessage get statusMessage => StatusMessage.none;

  int get countUnreadMessage => 10;

  DateTime get updatedAt =>
      (latestMessage?.updatedAt ?? createdAt ?? DateTime.now()).toLocal();

  String get inviteLink => 'https:/waterbus.tech/meeting/$code';

  List<OptionModel> get getOptions {
    final List<OptionModel> options = [];

    if (isOwner) {
      options.add(
        OptionModel(
          title: Strings.archivedChats.i18n,
          iconData: PhosphorIcons.archive(),
          handlePressed: () {
            AppBloc.chatBloc.add(ChatArchived(room: this));
          },
        ),
      );
    }

    options.add(
      OptionModel(
        title: Strings.delete.i18n,
        isDanger: true,
        iconData: PhosphorIcons.trash(),
        handlePressed: () {
          AppBloc.chatBloc.add(ChatDeleted(room: this));
        },
      ),
    );

    if (!isOwner) {
      options.add(
        OptionModel(
          title: Strings.leaveTheConversation.i18n,
          isDanger: true,
          iconData: PhosphorIcons.signOut(),
          handlePressed: () {
            AppBloc.chatBloc.add(ChatLeft(room: this));
          },
        ),
      );
    }

    return options;
  }

  User? get host {
    final Member? member = members.firstWhereOrNull(
      (member) => member.role == RoomRole.onwer,
    );

    return member?.user;
  }

  bool get isOwner => host?.id == AppBloc.userBloc.user?.id;

  String get updateAtText {
    final bool isToday = (updatedAt.day - DateTime.now().day) == 0;

    if (isToday) {
      return DateFormat("HH:mm").format(updatedAt);
    } else {
      return DateFormat(
        LanguageRepositoryImpl().getIsLanguage("vi") ? 'dd MMM' : 'dd/MM',
      ).format(updatedAt);
    }
  }
}
