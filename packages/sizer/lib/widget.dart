part of 'sizer.dart';

/// Provides `Context`, `Orientation`, and `DeviceType` parameters to the builder function
typedef ResponsiveBuild = Widget Function(
  BuildContext context,
  Orientation orientation,
  DeviceType deviceType,
);

/// A widget that gets the device's details like orientation and constraints
///
/// Usage: Wrap MaterialApp with this widget
class Sizer extends StatelessWidget {
  const Sizer({super.key, required this.builder});

  /// Builds the widget whenever the orientation changes
  final ResponsiveBuild builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizerUtil.setScreenSize(constraints, orientation);
            context.rebuildAllChildren();

            return builder(context, orientation, SizerUtil.deviceType);
          },
        );
      },
    );
  }
}
