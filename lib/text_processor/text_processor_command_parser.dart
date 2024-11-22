part of 'text_processor.dart';

class TextProcessorCommandParser
    implements CommandParser<TextProcessor, TextProcessorCommandInvoker> {
  static final RegExp pattern = RegExp(r'^(\w+).*?$');

  TextProcessorCommandParser({
    required TextProcessor textProcessor,
    required VoidCallback undoCallback,
    required VoidCallback redoCallback,
  })  : _textProcessor = textProcessor,
        _undoCallback = undoCallback,
        _redoCallback = redoCallback;

  final TextProcessor _textProcessor;
  final VoidCallback _undoCallback;
  final VoidCallback _redoCallback;

  @override
  Stream<Command<TextProcessor>> parse(String path) async* {
    final lines = await File(path).readAsLines();

    for (var line in lines) {
      if (line.isEmpty) continue;

      final match = pattern.firstMatch(line);
      if (match == null) throw InvalidInputException();

      switch (match.group(1)) {
        case TextProcessorUndoCommand.keyword:
          final subMatch = TextProcessorUndoCommand.pattern.firstMatch(line);
          if (subMatch == null) throw InvalidArgumentsException();
          yield TextProcessorUndoCommand(undoCallback: _undoCallback);
          break;
        case TextProcessorRedoCommand.keyword:
          final subMatch = TextProcessorRedoCommand.pattern.firstMatch(line);
          if (subMatch == null) throw InvalidArgumentsException();
          yield TextProcessorRedoCommand(redoCallback: _redoCallback);
          break;
        case TextProcessorCopyCommand.keyword:
          final subMatch = TextProcessorCopyCommand.pattern.firstMatch(line);
          if (subMatch == null) throw InvalidArgumentsException();
          yield TextProcessorCopyCommand(
            textProcessor: _textProcessor,
            idx1: int.parse(subMatch.group(1)!),
            idx2: int.parse(subMatch.group(2)!),
          );
          break;
        case TextProcessorDeleteCommand.keyword:
          final subMatch = TextProcessorDeleteCommand.pattern.firstMatch(line);
          if (subMatch == null) throw InvalidArgumentsException();
          yield TextProcessorDeleteCommand(
            textProcessor: _textProcessor,
            idx1: int.parse(subMatch.group(1)!),
            idx2: int.parse(subMatch.group(2)!),
          );
          break;
        case TextProcessorInsertCommand.keyword:
          final subMatch = TextProcessorInsertCommand.pattern.firstMatch(line);
          if (subMatch == null) throw InvalidArgumentsException();
          yield TextProcessorInsertCommand(
            textProcessor: _textProcessor,
            string: subMatch.group(1)!,
            idx: int.parse(subMatch.group(2)!),
          );
          break;
        case TextProcessorPasteCommand.keyword:
          final subMatch = TextProcessorPasteCommand.pattern.firstMatch(line);
          if (subMatch == null) throw InvalidArgumentsException();
          yield TextProcessorPasteCommand(
            textProcessor: _textProcessor,
            idx: int.parse(subMatch.group(1)!),
          );
          break;
        default:
          throw UnknownCommandException();
      }
    }
  }
}
