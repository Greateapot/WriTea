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
  List<Command<TextProcessor>> parseFile(String path) {
    final lines = File(path).readAsLinesSync();

    return parseLines(lines);
  }

  @override
  List<Command<TextProcessor>> parseLines(List<String> lines) {
    final List<Command<TextProcessor>> commands = [];

    for (var line in lines) {
      if (line.isEmpty) continue;

      final match = pattern.firstMatch(line);
      if (match == null) throw InvalidInputException();

      switch (match.group(1)) {
        case TextProcessorUndoCommand.keyword:
          commands.add(_parseTextProcessorUndoCommand(line));
          break;
        case TextProcessorRedoCommand.keyword:
          commands.add(_parseTextProcessorRedoCommand(line));
          break;
        case TextProcessorCopyCommand.keyword:
          commands.add(_parseTextProcessorCopyCommand(line));
          break;
        case TextProcessorDeleteCommand.keyword:
          commands.add(_parseTextProcessorDeleteCommand(line));
          break;
        case TextProcessorInsertCommand.keyword:
          commands.add(_parseTextProcessorInsertCommand(line));
          break;
        case TextProcessorPasteCommand.keyword:
          commands.add(_parseTextProcessorPasteCommand(line));
          break;
        default:
          throw UnknownCommandException();
      }
    }

    return commands;
  }

  Command<TextProcessor> _parseTextProcessorUndoCommand(String line) {
    final match = TextProcessorUndoCommand.pattern.firstMatch(line);
    if (match == null) throw InvalidArgumentsException();

    return TextProcessorUndoCommand(undoCallback: _undoCallback);
  }

  Command<TextProcessor> _parseTextProcessorRedoCommand(String line) {
    final match = TextProcessorRedoCommand.pattern.firstMatch(line);
    if (match == null) throw InvalidArgumentsException();

    return TextProcessorRedoCommand(redoCallback: _redoCallback);
  }

  Command<TextProcessor> _parseTextProcessorCopyCommand(String line) {
    final match = TextProcessorCopyCommand.pattern.firstMatch(line);
    if (match == null) throw InvalidArgumentsException();

    /// num -> index
    final idx1 = int.parse(match.group(1)!) - 1;
    final idx2 = int.parse(match.group(2)!) - 1;

    return TextProcessorCopyCommand(
      textProcessor: _textProcessor,
      idx1: idx1,
      idx2: idx2,
    );
  }

  Command<TextProcessor> _parseTextProcessorDeleteCommand(String line) {
    final match = TextProcessorDeleteCommand.pattern.firstMatch(line);
    if (match == null) throw InvalidArgumentsException();

    /// num -> index
    final idx1 = int.parse(match.group(1)!) - 1;
    final idx2 = int.parse(match.group(2)!) - 1;

    return TextProcessorDeleteCommand(
      textProcessor: _textProcessor,
      idx1: idx1,
      idx2: idx2,
    );
  }

  Command<TextProcessor> _parseTextProcessorInsertCommand(String line) {
    final match = TextProcessorInsertCommand.pattern.firstMatch(line);
    if (match == null) throw InvalidArgumentsException();

    /// num -> index
    final string = match.group(1)!;
    final idx = int.parse(match.group(2)!) - 1;

    return TextProcessorInsertCommand(
      textProcessor: _textProcessor,
      string: string,
      idx: idx,
    );
  }

  Command<TextProcessor> _parseTextProcessorPasteCommand(String line) {
    final match = TextProcessorPasteCommand.pattern.firstMatch(line);
    if (match == null) throw InvalidArgumentsException();

    /// num -> index
    final idx = int.parse(match.group(1)!) - 1;

    return TextProcessorPasteCommand(
      textProcessor: _textProcessor,
      idx: idx,
    );
  }
}
