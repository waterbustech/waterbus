import 'dart:ui';
import 'dart:core';

import 'package:waterbus/core/constants/avatar_colors.dart';
import 'package:waterbus/features/conversation/xmodels/string_extension.dart';

class DefaultAvatarModel {
  final String keyword;
  final Color backgroundColor;

  DefaultAvatarModel({
    required this.keyword,
    required this.backgroundColor,
  });

  factory DefaultAvatarModel.fromFullName(String name) {
    return DefaultAvatarModel(
      keyword: name.substring(0, 1),
      backgroundColor: generateColorFromName(name.substring(0, 1)),
    );
  }

  static DefaultAvatarModel defaultAvatarConstant = DefaultAvatarModel(
    keyword: 'A',
    backgroundColor: generateColorFromName('A'),
  );

  static Color generateColorFromName(String? keyword) {
    if (keyword == null || keyword.isEmpty) {
      return ConstantColor.colorDefault;
    }

    final String lastName = keyword.toUpperCase().formatVietnamese()[0];

    return ConstantColor.colorIntial[lastName] ?? ConstantColor.colorDefault;
  }
}
