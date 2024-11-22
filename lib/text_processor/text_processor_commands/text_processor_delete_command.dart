part of '../text_processor.dart';

class TextProcessorDeleteCommand implements UndoableCommand<TextProcessor> {
  static const String keyword = 'delete';
  static final RegExp pattern = RegExp(r'^delete\s*(\d+)\s*,\s*(\d+)\s*$');

  TextProcessorDeleteCommand({
    required TextProcessor textProcessor,
    required this.idx1,
    required this.idx2,
  }) : _textProcessor = textProcessor;

  final TextProcessor _textProcessor;
  final int idx1;
  final int idx2;

  TextProcessorState? _backup;

  @override
  void execute() {
    _backup = _textProcessor._state;
    _textProcessor.delete(idx1, idx2);
  }

  @override
  void undo() {
    if (_backup == null) throw InvalidStateException();

    final backup = _textProcessor._state;
    _textProcessor._restore(_backup!);
    _backup = backup;
  }

  @override
  void redo() {
    if (_backup == null) throw InvalidStateException();

    final backup = _textProcessor._state;
    _textProcessor._restore(_backup!);
    _backup = backup;
  }

  @override
  String toString() => 'TextProcessorDeleteCommand(idx1: $idx1, idx2: $idx2)';
}
