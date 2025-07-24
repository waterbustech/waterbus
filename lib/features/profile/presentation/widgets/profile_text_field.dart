import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/common/widgets/textfield/text_field_input.dart';

class ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final EdgeInsetsGeometry? margin;
  final Function()? onEditingComplete;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validatorForm;
  final FocusNode? focusNode;
  final Color? filledColor;

  const ProfileTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.margin,
    this.onEditingComplete,
    this.onChanged,
    this.inputFormatters,
    this.validatorForm,
    this.focusNode,
    this.filledColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: filledColor ?? _defaultFillColor(context),
        borderRadius: BorderRadius.circular(2.sp),
        boxShadow: filledColor != null
            ? []
            : [
                BoxShadow(
                  color: const Color(0xFF44475A).withValues(alpha: .5),
                  offset: const Offset(0, 2),
                  blurRadius: 2,
                  spreadRadius: 0.5,
                ),
                BoxShadow(
                  color: const Color(0xFF6272A4).withValues(alpha: .2),
                  offset: const Offset(0, 1),
                  blurRadius: 1,
                  spreadRadius: 0.3,
                ),
              ],
      ),
      child: TextFieldInput(
        focusNode: focusNode,
        onEditingComplete: onEditingComplete,
        contentPadding: EdgeInsets.symmetric(
          vertical: context.isDesktop ? 12.sp : 10.sp,
          horizontal: 12.sp,
        ),
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        validatorForm: validatorForm ?? (val) => null,
        hintText: hintText,
        hintStyle: TextStyle(
          color: colorGray3,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2.sp),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.transparent,
        controller: controller,
      ),
    );
  }

  Color _defaultFillColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).colorScheme.surfaceBright
        : Theme.of(context).colorScheme.surfaceContainerHighest;
  }
}
