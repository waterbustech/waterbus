// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/app/colors/app_color.dart';

// Project imports:
import 'package:waterbus/features/common/widgets/textfield/text_field_input.dart';

class ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final EdgeInsetsGeometry? margin;

  const ProfileTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldInput(
      margin: margin,
      contentPadding: EdgeInsets.symmetric(
        vertical: SizerUtil.isDesktop ? 12.sp : 6.sp,
        horizontal: 12.sp,
      ),
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
      fillColor: colorBlueGreyDark,
      controller: controller,
    );
  }
}
