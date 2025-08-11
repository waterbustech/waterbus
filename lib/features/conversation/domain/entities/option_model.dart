import 'package:flutter/material.dart';

class OptionModel {
  final String title;
  final Function()? handlePressed;
  final IconData iconData;
  final bool isDanger;
  OptionModel({
    required this.title,
    this.handlePressed,
    required this.iconData,
    this.isDanger = false,
  });
}
