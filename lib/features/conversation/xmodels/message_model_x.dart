import 'package:flutter/material.dart';

import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/widgets/bottom_sheet_delete.dart';
import 'package:waterbus/features/conversation/bloc/message_bloc.dart';
import 'package:waterbus/features/conversation/xmodels/option_model.dart';

extension MessageModelX on MessageModel {
  String get dataX => isDeleted
      ? "${isMe ? Strings.you.i18n : createdBy?.fullName ?? Strings.user.i18n} ${Strings.unsentAMessage.i18n}"
      : data;

  List<OptionModel> get getOptions {
    final List<OptionModel> options = [];

    if (isMe) {
      options.add(
        OptionModel(
          title: Strings.edit.i18n,
          handlePressed: () {
            AppBloc.messageBloc.add(SelectMessageEditEvent(message: this));
          },
        ),
      );

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
                  description: Strings.sureDeleteMessage.i18n,
                  handlePressed: () {
                    AppBloc.messageBloc.add(DeleteMessageEvent(messageId: id));
                  },
                );
              },
            );
          },
        ),
      );
    }

    return options;
  }

  bool get isMe => createdBy?.id == AppBloc.userBloc.user?.id;
}
