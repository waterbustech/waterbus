import 'package:waterbus_sdk/types/models/draw_model.dart';

class UndoRedoStack {
  final List<DrawModel> strokes;
  final DrawModel? currentStroke;
  final List<DrawModel> _undoStack = [];
  final List<DrawModel> _redoStack = [];

  UndoRedoStack({
    required this.strokes,
    this.currentStroke,
  });

  void addStroke(DrawModel stroke) {
    strokes.add(stroke);
    _undoStack.add(stroke);
    _redoStack.clear();
  }

  void undo() {
    if (_undoStack.isNotEmpty) {
      final lastStroke = _undoStack.removeLast();
      _redoStack.add(lastStroke);
      strokes.remove(lastStroke);
    }
  }

  void redo() {
    if (_redoStack.isNotEmpty) {
      final lastRedoStroke = _redoStack.removeLast();
      strokes.add(lastRedoStroke);
      _undoStack.add(lastRedoStroke);
    }
  }
}
