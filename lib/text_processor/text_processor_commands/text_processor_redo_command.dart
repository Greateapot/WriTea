part of '../text_processor.dart';

class TextProcessorRedoCommand implements Command<TextProcessor> {
  static const String keyword = 'redo';
  static final RegExp pattern = RegExp(r'^redo\s*$');

  TextProcessorRedoCommand({
    required VoidCallback redoCallback,
  }) : _redoCallback = redoCallback;

  final VoidCallback _redoCallback;

  @override
  void execute() => _redoCallback();

  @override
  String toString() => 'TextProcessorRedoCommand()';
}
