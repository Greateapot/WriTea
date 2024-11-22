part of '../text_processor.dart';

class TextProcessorUndoCommand implements Command<TextProcessor> {
  static const String keyword = 'undo';
  static final RegExp pattern = RegExp(r'^undo\s*$');

  TextProcessorUndoCommand({
    required VoidCallback undoCallback,
  }) : _undoCallback = undoCallback;

  final VoidCallback _undoCallback;

  @override
  void execute() => _undoCallback();

  @override
  String toString() => 'TextProcessorUndoCommand()';
}
