// Flutter imports:
import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  void rebuildAllChildren() {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (this as Element).visitChildren(rebuild);
  }
}
