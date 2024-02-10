part of 'sizer.dart';

const int inchToDP = 160;

extension SizerExt on num {
  /// Calculates the height depending on the device's screen size
  ///
  /// Eg: 20.h -> will take 20% of the screen's height
  double get h => this * SizerUtil.height / 100;

  /// Calculates the width depending on the device's screen size
  ///
  /// Eg: 20.w -> will take 20% of the screen's width
  double get w => this * SizerUtil.width / 100;

  /// Calculates the sp (Scalable Pixel) depending on the device's screen size
  // double get sp => this * (SizerUtil.width / 3) / 100;

  double get width {
    // DEVICE INCH
    final double deviceSize =
        math.sqrt(100.h * 100.h + 100.w * 100.w) / inchToDP;
    if (SizerUtil.isTablet) {
      // Square device
      if ((100.h - 100.w).abs() < 100) {
        return 300 * math.max(1.h / 1.w, 1.w / 1.h);
      }

      late double aspectRatio;

      aspectRatio = 1.h / 1.w > 1.45 || 1.w / 1.h > 1.45
          ? math.min(1.h / 1.w, 1.w / 1.h)
          : 1.h / 1.w;

      return 290 * math.max(math.min(1.35, aspectRatio), 1.15);
    } else if (deviceSize > 5.5) {
      return 100.w;
    } else if (deviceSize > 5.0) {
      return 90.w;
    } else {
      return 85.w;
    }
  }

  double get sp => this * (width / 3) / 100;
}
