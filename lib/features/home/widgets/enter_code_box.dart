// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';

class EnterCodeBox extends StatefulWidget {
  final Function()? onTap;
  final EdgeInsetsGeometry? margin;
  final Function(String)? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final String hintTextContent;
  const EnterCodeBox({
    super.key,
    this.onTap,
    this.margin,
    this.onChanged,
    this.contentPadding = EdgeInsets.zero,
    this.hintTextContent = "Enter code to join meeting",
  });

  @override
  State<StatefulWidget> createState() => _EnterCodeBoxState();
}

class _EnterCodeBoxState extends State<EnterCodeBox> {
  TextEditingController searchKey = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();

    searchKey.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      margin: widget.margin ?? EdgeInsets.symmetric(horizontal: 10.sp),
      height: 36.sp,
      child: TextFormField(
        autofocus: widget.onTap == null,
        readOnly: widget.onTap != null,
        onTap: widget.onTap,
        controller: searchKey,
        style: TextStyle(
          color: mC,
          fontSize: 11.sp,
        ),
        keyboardType: TextInputType.number,
        minLines: 1,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6),
        ],
        decoration: InputDecoration(
          contentPadding: widget.contentPadding,
          hintText: widget.hintTextContent,
          hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 12.sp,
              ),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black.withOpacity(.2)
              : mC,
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
        onChanged: widget.onChanged ??
            (val) {
              if (_debounce?.isActive ?? false) _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () {});

              setState(() {});
            },
      ),
    );
  }
}
