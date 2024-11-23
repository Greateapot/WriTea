class Receiver {}

abstract interface class Command<R extends Receiver> {
  void execute();
}

abstract interface class UndoableCommand<R extends Receiver>
    implements Command<R> {
  void undo();
  void redo();
}

abstract interface class Invoker<R extends Receiver> {
  void process(final List<Command<R>> commands);
}

abstract interface class CommandParser<R extends Receiver,
    I extends Invoker<R>> {
  List<Command<R>> parseFile(String path);
  List<Command<R>> parseLines(List<String> lines);
}
