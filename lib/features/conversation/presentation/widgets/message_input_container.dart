import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/app/languages/localization.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/conversation/presentation/bloc/message_bloc.dart';

class MessageInputContainer extends StatefulWidget {
  final int roomId;
  final Color? backgroundColor;
  final BorderRadius borderRadius;
  const MessageInputContainer({
    super.key,
    required this.roomId,
    this.backgroundColor,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  State<MessageInputContainer> createState() => _MessageInputContainerState();
}

class _MessageInputContainerState extends State<MessageInputContainer> {
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
    return Material(
      clipBehavior: Clip.hardEdge,
      shape: SuperellipseShape(
        borderRadius: widget.borderRadius,
      ),
      color: Colors.transparent,
      child: Container(
        height: 60.sp,
        alignment: Alignment.center,
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
        child: BlocBuilder<MessageBloc, MessageState>(
          builder: (context, state) {
            final Message? messageBeingEdited =
                state is MessageActived ? state.messageBeingEdited : null;

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

            return CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.enter): () {
                  _handleSendMessage(
                    messageBeingEdited: messageBeingEdited,
                  );
                },
              },
              child: Container(
                padding: EdgeInsets.only(right: 2.75.sp),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(2.sp),
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
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.sp),
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
                          AppBloc.messageBloc.add(MessageEditingCancelled());
                        } else {
                          _handleSendMessage(
                            messageBeingEdited: messageBeingEdited,
                          );
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4.sp),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        padding: EdgeInsets.all(8.sp),
                        child: Icon(
                          LucideIcons.arrowUp,
                          size: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleSendMessage({Message? messageBeingEdited}) {
    if (messageBeingEdited != null) {
      AppBloc.messageBloc.add(
        MessageEdited(
          data: _messageController.text.trim(),
          messageId: messageBeingEdited.id,
        ),
      );
    } else {
      AppBloc.messageBloc.add(
        MessageSent(
          data: _messageController.text.trim(),
          roomId: widget.roomId,
        ),
      );
    }

    _messageController.clear();
  }
}
