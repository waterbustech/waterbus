import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:waterbus_sdk/types/enums/meeting_role.dart';
import 'package:waterbus_sdk/types/index.dart';
import 'package:waterbus_sdk/types/models/index.dart';
import 'package:waterbus_sdk/types/models/message_status_enum.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/conversation/xmodels/message_model_x.dart';
import 'package:waterbus/features/conversation/xmodels/option_model.dart';
import 'package:waterbus/features/settings/lang/language_service.dart';

extension MeetingModelX on Meeting {
  String get latestMessageData => latestMessage != null
      ? "${latestMessage!.isMe && latestMessage!.status != MessageStatusEnum.inactive ? "${Strings.you.i18n}: " : ""}${latestMessage!.dataX}"
      : Strings.groupCreated.i18n;

  List<OptionModel> get getOptions {
    final List<OptionModel> options = [];

    options.add(
      OptionModel(
        title: isHost ? Strings.archivedChats.i18n : Strings.delete.i18n,
        isDanger: true,
        handlePressed: () {
          AppBloc.chatBloc.add(ArchivedOrLeaveConversationEvent(meeting: this));
        },
      ),
    );

    return options;
  }

  User? get host {
    final Member? member =
        members.firstWhereOrNull((member) => member.role == MeetingRole.host);

    return member?.user;
  }

  bool get isHost => host?.id == AppBloc.userBloc.user?.id;

  String get updateAtText {
    final bool isToday = (updatedAt.day - DateTime.now().day) == 0;

    if (isToday) {
      return DateFormat("HH:mm").format(updatedAt);
    } else {
      return DateFormat(
        LanguageService().getIsLanguage("vi") ? 'dd MMM' : 'dd/MM',
      ).format(updatedAt);
    }
  }
}
