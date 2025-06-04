part of '../sizer.dart';

enum ScreenType { mobile, tablet, desktop }

const double maxMobileWidth = 599;
const double maxTabletWidth = 1024;
const double oneInch = 160;

class SizerUtils {
  late Size cachedScreenSize;
  late ScreenType screenType;
  late double aspectRatio;
  late double scalableWidth;

  final Map<num, double> _cachedScalablePixel = {};

  void onScreenSizeChanged(
    BuildContext context,
    BoxConstraints constraints,
    Orientation orientation,
  ) {
    _cachedScalablePixel.clear();

    final Size screenSize = Size(constraints.maxWidth, constraints.maxHeight);

    cachedScreenSize = screenSize;
    screenType = getScreenType(screenSize, orientation);

    aspectRatio = 1 / screenSize.aspectRatio;

    scalableWidth = _calculateScalableWidth;
  }

  ScreenType getScreenType(Size size, Orientation orientation) {
    final double width = size.width;
    final double height = size.height;

    // Sets ScreenType
    if ((orientation == Orientation.portrait && width <= maxMobileWidth) ||
        (orientation == Orientation.landscape && height <= maxMobileWidth)) {
      return ScreenType.mobile;
    } else if ((orientation == Orientation.portrait &&
            width <= maxTabletWidth) ||
        (orientation == Orientation.landscape && height <= maxTabletWidth)) {
      return ScreenType.tablet;
    }

    return ScreenType.desktop;
  }

  double sp(num number) {
    if (_cachedScalablePixel[number] == null) {
      _cachedScalablePixel[number] = number * scalableWidth / 300;
    }

    return _cachedScalablePixel[number] ?? 1;
  }

  double get _calculateScalableWidth {
    // Constants for 100 unit size
    final double deviceWidth = cachedScreenSize.width;
    final double deviceHeight = cachedScreenSize.height;

    // Calculate device size in inches
    final double deviceSize =
        math.sqrt(deviceHeight * deviceHeight + deviceWidth * deviceWidth) /
            oneInch;

    // Handle both mobile and non-mobile scenarios
    if (!(screenType == ScreenType.mobile) || kIsWeb) {
      // Check if the device is a square
      if ((deviceHeight - deviceWidth).abs() < 100) {
        return 300 *
            math.max(
              deviceHeight / deviceWidth,
              deviceWidth / deviceHeight,
            );
      }

      return 300 *
          math.max(
            math.min(1.35, SizerUtils.instance.aspectRatio),
            1.125,
          );
    } else {
      // Handle device size for mobile scenarios
      if (deviceSize > 5.5) {
        return deviceWidth; // Large device
      } else if (deviceSize > 5.0) {
        return 90.w; // Medium device
      } else {
        return 85.w; // Small device
      }
    }
  }

  bool get isMinimunSizeSupport =>
      kIsWeb && (cachedScreenSize.width < 800 || cachedScreenSize.height < 600);

  static final SizerUtils instance = SizerUtils._internal();

  factory SizerUtils() {
    return instance;
  }

  SizerUtils._internal();
}
