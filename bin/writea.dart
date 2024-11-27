// ignore_for_file: avoid_print

import 'dart:io';

import 'package:writea/text_processor/text_processor.dart';

void main(List<String> args) async {
  if (args.length < 2) {
    print('Not enough args. Usage: writea '
        '"path/to/commands.txt" "path/to/string.txt"');
    return;
  }

  final commandsPath = args[0];
  final stringPath = args[1];

  final file = File(stringPath);
  final initialValue = await file.readAsString();

  final initialState = TextProcessorState.value(
    initialValue: initialValue,
  );

  final textProcessorController = TextProcessorController(
    initialState: initialState,
  );

  final textProcessor = TextProcessor(
    controller: textProcessorController,
  );

  final invoker = TextProcessorCommandInvoker();

  final parser = TextProcessorCommandParser(
    textProcessor: textProcessor,
    undoCallback: invoker.undo,
    redoCallback: invoker.redo,
  );

  print('Initial text: "${textProcessorController.value.text}"');

  invoker.process(parser.parseFile(commandsPath));

  print('Result text: "${textProcessorController.value.text}"');
}
