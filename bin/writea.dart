// ignore_for_file: avoid_print

import 'package:writea/text_processor/text_processor.dart';

void main() async {
  const initialValue = "hello world";

  final initialState = TextProcessorState.value(initialValue);
  final textProcessorController = TextProcessorController(initialState);
  final textProcessor = TextProcessor(textProcessorController);

  final invoker = TextProcessorCommandInvoker();
  final parser = TextProcessorCommandParser(
    textProcessor: textProcessor,
    undoCallback: invoker.undo,
    redoCallback: invoker.redo,
  );

  print('Initial text: "${textProcessorController.value.text}"');

  invoker.process(parser.parseFile('writea_pyb/example.txt'));

  print('Result text: "${textProcessorController.value.text}"');
}
