import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';

import 'package:waterbus/core/utils/input_formatter/room_code_formatter.dart';

class EnterCodeBox extends StatefulWidget {
  final Function()? onTap;
  final EdgeInsetsGeometry? margin;
  final Function(String)? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final String? hintTextContent;
  final TextEditingController? controller;
  final void Function(String)? onFieldSubmitted;
  final Widget? suffixWidget;
  const EnterCodeBox({
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
  State<StatefulWidget> createState() => _EnterCodeBoxState();
}

class _EnterCodeBoxState extends State<EnterCodeBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? EdgeInsets.symmetric(horizontal: 10.sp),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Material(
              clipBehavior: Clip.hardEdge,
              shape: SuperellipseShape(
                borderRadius: BorderRadius.circular(25.sp),
              ),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: SizedBox(
                width: 100.w,
                height: 36.sp,
                child: TextFormField(
                  autofocus: widget.onTap == null,
                  readOnly: widget.onTap != null,
                  onTap: widget.onTap,
                  controller: widget.controller,
                  onFieldSubmitted: widget.onFieldSubmitted,
                  style: TextStyle(
                    fontSize: 12.sp,
                  ),
                  keyboardType: TextInputType.number,
                  minLines: 1,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(9),
                    RoomCodeFormatter(),
                  ],
                  decoration: InputDecoration(
                    contentPadding: widget.contentPadding,
                    hintText: widget.hintTextContent ??
                        Strings.enterCodeToJoinMeeting.i18n,
                    hintStyle: TextStyle(
                      fontSize: 12.sp,
                    ),
                    filled: true,
                    fillColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.sp),
                      borderSide: BorderSide.none,
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
                              PhosphorIcons.magnifying_glass_bold,
                              size: 14.sp,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
          widget.suffixWidget ?? const SizedBox(),
        ],
      ),
    );
  }
}
