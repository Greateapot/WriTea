// ignore_for_file: avoid_print

import 'package:writea/text_processor/text_processor.dart';

void main() async {
  const initialValue = "Hello, World!";

  final textProcessor = TextProcessor(TextProcessorState.value(initialValue));
  final invoker = TextProcessorCommandInvoker();
  final parser = TextProcessorCommandParser(
    textProcessor: textProcessor,
    undoCallback: invoker.undo,
    redoCallback: invoker.redo,
  );

  print('Initial value: "$initialValue"');

  final commands = await parser.parse('writea_pyb/example.txt').toList();

  invoker.process(commands);

  print('Result value: "${textProcessor.value}"');
}
