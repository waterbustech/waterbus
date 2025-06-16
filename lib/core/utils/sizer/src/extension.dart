part of '../sizer.dart';

extension SizerExt on num {
  /// Calculates the height depending on the device's screen size
  ///
  /// Eg: 20.h -> will take 20% of the screen's height
  double get h => this * _size.height / 100;

  /// Calculates the width depending on the device's screen size
  ///
  /// Eg: 20.w -> will take 20% of the screen's width
  double get w => this * _size.width / 100;

  /// Calculates the sp (Scalable Pixel) depending on the device's pixel
  /// density and aspect ratio
  double get sp => SizerUtils.instance.sp(this);

  BuildContext? get _context => AppRouter.context;

  Size get _size {
    if (_context != null) {
      return _context!.sizer.size;
    }

    return SizerUtils.instance.cachedScreenSize;
  }
}
