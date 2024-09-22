import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sizer/sizer.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/features/common/widgets/textfield/text_field_input.dart';

class ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final EdgeInsetsGeometry? margin;
  final Function()? onEditingComplete;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  const ProfileTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.margin,
    this.onEditingComplete,
    this.onChanged,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldInput(
      onEditingComplete: onEditingComplete,
      margin: margin,
      contentPadding: EdgeInsets.symmetric(
        vertical: SizerUtil.isDesktop ? 12.sp : 10.sp,
        horizontal: 12.sp,
      ),
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      validatorForm: (val) => null,
      hintText: hintText,
      hintStyle: TextStyle(
        color: colorGray3,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7.sp),
        borderSide: BorderSide.none,
      ),
      fillColor: Theme.of(context).colorScheme.onInverseSurface,
      controller: controller,
    );
  }
}
