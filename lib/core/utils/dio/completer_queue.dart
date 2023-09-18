// Dart imports:
import 'dart:async';
import 'dart:collection';

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
      next?.complete(result);
    }
  }
}
