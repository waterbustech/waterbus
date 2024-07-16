import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:waterbus_sdk/types/enums/meeting_role.dart';
import 'package:waterbus_sdk/types/index.dart';
import 'package:waterbus_sdk/types/models/index.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/chats/presentation/widgets/bottom_sheet_delete.dart';
import 'package:waterbus/features/conversation/xmodels/option_model.dart';

extension MeetingModelX on Meeting {
  List<OptionModel> get getOptions {
    final List<OptionModel> options = [];

    options.add(
      OptionModel(
        title: Strings.delete.i18n,
        isDanger: true,
        handlePressed: () {
          showModalBottomSheet(
            context: AppNavigator.context!,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            barrierColor: Colors.black38,
            enableDrag: false,
            builder: (context) {
              return BottomSheetDelete(
                handlePressed: () {
                  AppBloc.chatBloc.add(DeleteConversationEvent(meetingId: id));
                },
              );
            },
          );
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
}
