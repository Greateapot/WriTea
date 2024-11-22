part of 'text_processor.dart';

class TextProcessorCommandInvoker implements Invoker<TextProcessor> {
  TextProcessorCommandInvoker();

  final Stack<UndoableCommand<TextProcessor>> _undoHistory = Stack();
  final Stack<UndoableCommand<TextProcessor>> _redoHistory = Stack();

  @override
  void process(List<Command<TextProcessor>> commands) {
    if (commands.isEmpty) return;

    _redoHistory.clear();

    for (var command in commands) {
      dev.log('Invoking command: $command');
      command.execute();
      if (command is UndoableCommand<TextProcessor>) {
        _undoHistory.push(command);
      }
    }
  }

  void undo() {
    if (_undoHistory.isEmpty) return;

    final command = _undoHistory.pop();
    dev.log('Undoing command: $command');
    command.undo();
    _redoHistory.push(command);
  }

  void redo() {
    if (_redoHistory.isEmpty) return;

    final command = _redoHistory.pop();
    dev.log('Redoing command: $command');
    command.redo();
    _undoHistory.push(command);
  }
}
