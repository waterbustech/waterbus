import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/conversation/bloc/message_bloc.dart';

class InputSendMessage extends StatefulWidget {
  final int meetingId;
  const InputSendMessage({super.key, required this.meetingId});

  @override
  State<InputSendMessage> createState() => _InputSendMessageState();
}

class _InputSendMessageState extends State<InputSendMessage> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _flagEdit = false;

  void _requestFocus({bool isFocus = true}) {
    if (isFocus) {
      if (!_focusNode.hasFocus) {
        _focusNode.requestFocus();
      }
    } else {
      if (_focusNode.hasFocus) {
        _focusNode.unfocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizerUtil.isDesktop ? 48.sp : null,
      width: 100.w,
      padding: SizerUtil.isDesktop
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: 16.sp, vertical: 10.sp),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 0.4,
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          final MessageModel? messageBeingEdited =
              state is ActiveMessageState ? state.messageBeingEdited : null;

          if (messageBeingEdited != null) {
            if (!_flagEdit) {
              _messageController.text = messageBeingEdited.data;
              _flagEdit = true;
              _requestFocus();
            }
          } else {
            if (_flagEdit) {
              _flagEdit = false;

              _messageController.text = "";
            }
          }

          final bool dataEditing = messageBeingEdited != null &&
              (messageBeingEdited.data == _messageController.text.trim() ||
                  _messageController.text.isEmpty);

          return Container(
            padding: EdgeInsets.only(left: 6.sp, right: 2.75.sp),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: WebRTC.platformIsMobile
                  ? Theme.of(context).colorScheme.surfaceContainerHighest
                  : Colors.transparent,
              borderRadius: WebRTC.platformIsMobile
                  ? BorderRadius.circular(30.sp)
                  : BorderRadius.zero,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onFieldSubmitted: (val) => _handleSendMessage(
                      messageBeingEdited: messageBeingEdited,
                    ),
                    focusNode: _focusNode,
                    controller: _messageController,
                    style: TextStyle(fontSize: 12.sp),
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 2,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.sp,
                      ),
                      hintText: Strings.leaveAMessage.i18n,
                      hintStyle: TextStyle(fontSize: 12.sp),
                      filled: true,
                      fillColor: WebRTC.platformIsMobile
                          ? Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                          : Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: WebRTC.platformIsMobile
                            ? BorderRadius.circular(40.sp)
                            : BorderRadius.zero,
                        borderSide: BorderSide.none,
                      ),
                      hoverColor: Colors.transparent,
                    ),
                    onChanged: (val) {
                      setState(() {});
                    },
                  ),
                ),
                GestureWrapper(
                  isCloseKeyboard: false,
                  onTap: () {
                    if (dataEditing) {
                      _messageController.text = '';
                      _requestFocus(isFocus: false);
                      AppBloc.messageBloc.add(CancelEditMessageEvent());
                    } else {
                      _handleSendMessage(
                        messageBeingEdited: messageBeingEdited,
                      );
                    }
                  },
                  child: dataEditing
                      ? Padding(
                          padding: EdgeInsets.all(7.sp),
                          child: Icon(
                            PhosphorIcons.x,
                            color: WebRTC.platformIsMobile
                                ? mCL
                                : Theme.of(context).colorScheme.primary,
                            size: SizerUtil.isDesktop ? 22.sp : 18.sp,
                          ),
                        )
                      : Container(
                          decoration: WebRTC.platformIsMobile
                              ? BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                )
                              : null,
                          padding: EdgeInsets.all(7.sp),
                          child: Icon(
                            PhosphorIcons.paper_plane_right_fill,
                            color: WebRTC.platformIsMobile
                                ? mCL
                                : Theme.of(context).colorScheme.primary,
                            size: SizerUtil.isDesktop ? 22.sp : 18.sp,
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleSendMessage({MessageModel? messageBeingEdited}) {
    if (messageBeingEdited != null) {
      AppBloc.messageBloc.add(
        EditMessageEvent(
          data: _messageController.text.trim(),
          messageId: messageBeingEdited.id,
        ),
      );
    } else {
      AppBloc.messageBloc.add(
        SendMessageEvent(
          data: _messageController.text.trim(),
          meetingId: widget.meetingId,
        ),
      );
    }

    _messageController.clear();
  }
}
