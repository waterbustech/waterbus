import 'package:flutter/foundation.dart'; // for kIsWeb

import 'package:flutter/material.dart';

class WaterbusTransitionPageRoute<T> extends MaterialPageRoute<T> {
  WaterbusTransitionPageRoute({
    required super.builder,
    super.settings,
  });

  @override
  Duration get transitionDuration =>
      kIsWeb ? Duration.zero : const Duration(milliseconds: 200);

  @override
  Duration get reverseTransitionDuration =>
      kIsWeb ? Duration.zero : const Duration(milliseconds: 200);
}
