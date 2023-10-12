// Dart imports:
import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';

class CompleterQueue<T> {
  final Queue<Completer<T>> _completers = Queue();

  void add(Completer<T> completer) {
    _completers.add(completer);
  }

  Completer<T>? get next {
    if (_completers.isNotEmpty) {
      return _completers.removeFirst();
    }
    return null;
  }

  void completeAllQueue(T result) {
    while (_completers.isNotEmpty) {
      debugPrint("** Solve 1 queue ** refresh token");
      next?.complete(result);
    }
  }
}
