// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class TextFieldInput extends StatelessWidget {
  final String? Function(String?)? validatorForm;
  final void Function(String)? onChanged;
  final String hintText;
  final int maxLines;
  final int? maxLength;
  final bool isAvailable;
  final bool isActive;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final TextInputType? textInputType;
  final FocusNode? focusNode;
  final Color? colorTextField;
  final void Function()? onTap;
  final double? height;
  final AutovalidateMode? autovalidateMode;
  final bool readOnly;
  final Color? fillColor;
  final TextStyle? errorStyle;
  final InputBorder? errorBorder;
  final BorderSide? borderSide;
  const TextFieldInput({
    super.key,
    required this.validatorForm,
    required this.hintText,
    this.textInputType,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.isAvailable = true,
    this.isActive = true,
    this.controller,
    this.suffixIcon,
    this.inputFormatters,
    this.focusNode,
    this.colorTextField,
    this.onTap,
    this.height,
    this.autovalidateMode,
    this.readOnly = false,
    this.fillColor,
    this.errorStyle,
    this.errorBorder,
    this.borderSide,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: maxLength != null ? 0.0 : 10.sp,
        bottom: maxLength != null ? 4.sp : 0.0,
      ),
      width: double.infinity,
      child: TextFormField(
        onTap: onTap ?? () {},
        focusNode: focusNode,
        readOnly: readOnly,
        controller: controller,
        enabled: isAvailable && isActive,
        validator: validatorForm,
        style: TextStyle(
          fontSize: 12.sp,
          color: isAvailable
              ? Theme.of(context).textTheme.bodyMedium!.color
              : Theme.of(context).textTheme.titleMedium?.color,
          height: height,
        ),
        cursorColor: Theme.of(context).primaryColor,
        keyboardType: textInputType ?? TextInputType.multiline,
        onChanged: onChanged,
        maxLines: maxLines == 1 ? null : maxLines,
        inputFormatters: inputFormatters ??
            [
              LengthLimitingTextInputFormatter(maxLength),
            ],
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor ??
              (isAvailable
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Theme.of(context).colorScheme.background),
          hintText: hintText,
          errorStyle: errorStyle,
          errorBorder: errorBorder,
          focusedErrorBorder: errorBorder,
          focusedBorder: maxLength != null
              ? InputBorder.none
              : _outlineInputBorder(context),
          border: maxLength != null
              ? InputBorder.none
              : _outlineInputBorder(context),
          enabledBorder: maxLength != null
              ? InputBorder.none
              : _outlineInputBorder(context),
          disabledBorder: maxLength != null
              ? InputBorder.none
              : _outlineInputBorder(context),
          hintStyle: TextStyle(
            color: Theme.of(context).textTheme.labelSmall?.color,
            fontSize: 12.sp,
          ),
          isDense: maxLines == 1,
          contentPadding: maxLines == 1
              ? EdgeInsets.symmetric(
                  vertical: 11.sp,
                  horizontal: 10.sp,
                )
              : EdgeInsets.symmetric(
                  vertical: 8.sp,
                  horizontal: 10.sp,
                ),
          suffix: suffixIcon == null
              ? null
              : Padding(
                  padding: EdgeInsets.only(bottom: 1.25.sp),
                  child: suffixIcon,
                ),
        ),
        autovalidateMode:
            autovalidateMode ?? AutovalidateMode.onUserInteraction,
      ),
    );
  }

  OutlineInputBorder _outlineInputBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6.sp),
      borderSide: borderSide ??
          BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
    );
  }
}
