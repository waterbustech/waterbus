import 'package:waterbus/gen/assets.gen.dart';

enum SideBarOptions {
  code('Code Editor'),
  paint('White Board'),
  notes('Notes');

  const SideBarOptions(this.label);
  final String label;
}

extension SideBarOptionsX on SideBarOptions {
  String get iconAssetPath {
    switch (this) {
      case SideBarOptions.code:
        return Assets.icons.icCode.path;
      case SideBarOptions.paint:
        return Assets.icons.icPaint.path;
      case SideBarOptions.notes:
        return Assets.icons.icNotes.path;
    }
  }
}
