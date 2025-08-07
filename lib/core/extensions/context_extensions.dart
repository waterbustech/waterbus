import 'package:flutter/material.dart';

import 'package:waterbus/core/utils/sizer/src/sizer_extension.dart';

extension BuildContextX on BuildContext {
  SizerExtension get sizer {
    return Theme.of(this).extension<SizerExtension>()!;
  }

  bool get isMobile => sizer.isMobile;

  bool get isDesktop => sizer.isDesktop;

  bool get isLandscape => sizer.isLandscape;
}
