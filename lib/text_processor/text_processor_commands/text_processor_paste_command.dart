part of '../text_processor.dart';

class TextProcessorPasteCommand implements UndoableCommand<TextProcessor> {
  static const String keyword = 'paste';
  static final RegExp pattern = RegExp(r'^paste\s*(\d+)\s*$');

  TextProcessorPasteCommand({
    required TextProcessor textProcessor,
    required this.idx,
  }) : _textProcessor = textProcessor;

  final TextProcessor _textProcessor;
  final int idx;

  TextProcessorState? _backup;

  @override
  void execute() {
    _backup = _textProcessor._state;
    _textProcessor.paste(idx);
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
  String toString() => 'TextProcessorPasteCommand(idx: $idx)';
}
