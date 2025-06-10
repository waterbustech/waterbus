import 'package:flutter/material.dart';

import 'package:waterbus/core/constants/avatar_colors.dart';

class DefaultAvatarModel {
  final String keyword;
  final Color backgroundColor;
  final List<Color>? gradientColors;
  final bool useGradient;

  const DefaultAvatarModel({
    required this.keyword,
    required this.backgroundColor,
    this.gradientColors,
    this.useGradient = false,
  });

  factory DefaultAvatarModel.fromFullName(String fullName) {
    if (fullName.isEmpty) {
      return DefaultAvatarModel(
        keyword: '?',
        backgroundColor: ConstantColor.colorDefault,
      );
    }

    // Extract initials (first letter of each word, max 2)
    final words = fullName.trim().split(RegExp(r'\s+'));
    String initials = '';

    if (words.length == 1) {
      initials = words[0].substring(0, 1).toUpperCase();
    } else {
      initials = words
          .take(2)
          .map((word) => word.substring(0, 1).toUpperCase())
          .join();
    }

    // Get gradient colors based on first initial
    final firstInitial = initials[0].toUpperCase();
    final gradientColors = ConstantColor.colorGradientsByInitial[firstInitial];
    final fallbackColor =
        ConstantColor.colorIntial[firstInitial] ?? ConstantColor.colorDefault;

    return DefaultAvatarModel(
      keyword: initials,
      backgroundColor: fallbackColor,
      gradientColors: gradientColors,
      useGradient: gradientColors != null,
    );
  }
}
