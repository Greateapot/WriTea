part of '../text_processor.dart';

class TextProcessorInsertCommand implements UndoableCommand<TextProcessor> {
  static const String keyword = 'insert';
  static final RegExp pattern = RegExp(r'^insert\s*\"(.*?)\"\s*,\s*(\d+)\s*$');

  TextProcessorInsertCommand({
    required TextProcessor textProcessor,
    required this.string,
    required this.idx,
  }) : _textProcessor = textProcessor;

  final TextProcessor _textProcessor;
  final String string;
  final int idx;

  TextProcessorState? _backup;

  @override
  void execute() {
    _backup = _textProcessor._state;
    _textProcessor.insert(string, idx);
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
  String toString() => 'TextProcessorInsertCommand(string: $string, idx: $idx)';
}
