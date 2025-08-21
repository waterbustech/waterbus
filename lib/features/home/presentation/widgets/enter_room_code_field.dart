import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:waterbus/core/app/languages/localization.dart';
import 'package:waterbus/core/utils/input_formatter/room_code_formatter.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';

class EnterRoomCodeField extends StatefulWidget {
  final Function()? onTap;
  final EdgeInsetsGeometry? margin;
  final Function(String)? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final String? hintTextContent;
  final TextEditingController? controller;
  final void Function(String)? onFieldSubmitted;
  final Widget? suffixWidget;
  const EnterRoomCodeField({
    super.key,
    this.controller,
    this.onFieldSubmitted,
    this.onTap,
    this.margin,
    this.onChanged,
    this.contentPadding = EdgeInsets.zero,
    this.hintTextContent,
    this.suffixWidget,
  });

  @override
  State<StatefulWidget> createState() => _EnterRoomCodeFieldState();
}

class _EnterRoomCodeFieldState extends State<EnterRoomCodeField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? EdgeInsets.symmetric(horizontal: 10.sp),
      child: Row(
        spacing: 12.sp,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.3),
              ),
              width: 100.w,
              height: 36.sp,
              child: TextFormField(
                autofocus: widget.onTap == null,
                readOnly: widget.onTap != null,
                onTap: widget.onTap,
                controller: widget.controller,
                onFieldSubmitted: widget.onFieldSubmitted,
                style: TextStyle(fontSize: 11.sp),
                minLines: 1,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(12),
                  RoomCodeFormatter(),
                ],
                decoration: InputDecoration(
                  contentPadding: widget.contentPadding,
                  hintText: widget.hintTextContent ??
                      Strings.enterCodeToJoinMeeting.i18n,
                  hintStyle: TextStyle(
                    fontSize: 11.sp,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.sp),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.sp),
                    borderSide: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.sp),
                    borderSide: widget.onTap != null
                        ? BorderSide.none
                        : BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.5,
                          ),
                  ),
                  prefixIconConstraints: BoxConstraints(
                    maxHeight: 20.sp,
                    maxWidth: 36.sp,
                  ),
                  prefixIcon: widget.onTap != null
                      ? Container(
                          height: 20.sp,
                          width: 36.sp,
                          alignment: Alignment.center,
                          child: Icon(
                            PhosphorIcons.magnifyingGlass(
                              PhosphorIconsStyle.bold,
                            ),
                            size: 14.sp,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
          if (widget.suffixWidget != null) widget.suffixWidget!,
        ],
      ),
    );
  }
}
