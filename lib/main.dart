import 'dart:io';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:writea/observable_text_processor.dart';
import 'package:writea/text_processor/text_processor.dart';

Color get seedColor {
  final random = Random.secure();
  final r = random.nextInt(128) + 128;
  final g = random.nextInt(128) + 128;
  final b = random.nextInt(128) + 128;
  return Color.fromRGBO(r, g, b, 1);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    center: true,
    title: 'WriTea',
    windowButtonVisibility: true,
    skipTaskbar: false,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const Writea(),
    theme: ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
      ),
    ),
  ));
}

class Writea extends StatefulWidget {
  const Writea({super.key});

  @override
  State<Writea> createState() => _WriteaState();
}

class _WriteaState extends State<Writea> {
  late final ListenableTextProcessorController _textProcessorController;
  late final TextEditingController _initialStringTextEditingController;
  late final TextEditingController _resultStringTextEditingController;
  late final TextEditingController _commandsTextEditingController;
  late final TextEditingController _logsTextEditingController;

  Future<File?> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      initialDirectory: (await getApplicationDocumentsDirectory()).path,
      lockParentWindow: true,
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null) {
      return File(result.files.single.path!);
    }

    return null;
  }

  Future<File?> _saveFile() async {
    String? result = await FilePicker.platform.saveFile(
      initialDirectory: (await getApplicationDocumentsDirectory()).path,
      lockParentWindow: true,
      fileName: 'string.txt',
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null) {
      return File(result);
    }

    return null;
  }

  void _textProcessorControllerListener() {
    _logsTextEditingController.text +=
        '${_textProcessorController.value.text}\n';
  }

  Future<void> _onLoadStringPressed() async {
    final file = await _pickFile();

    if (file != null) {
      final text = await file.readAsString();

      /// ah yes... Windows...
      _initialStringTextEditingController.text = text.replaceAll('\r', '');
    }
  }

  Future<void> _onLoadCommandsPressed() async {
    final file = await _pickFile();

    if (file != null) {
      final text = await file.readAsString();

      /// ah yes... Windows...
      _commandsTextEditingController.text = text.replaceAll('\r', '');
    }
  }

  Future<void> _onSaveStringPressed() async {
    if (_resultStringTextEditingController.text.isEmpty) return;

    final file = await _saveFile();

    if (file != null) {
      await file.writeAsString(_resultStringTextEditingController.text);
    }
  }

  Future<void> _onClearLogsPressed() async {
    _logsTextEditingController.text = '';
  }

  Future<void> _onProcessPressed() async {
    _textProcessorController.value = TextProcessorState.value(
      initialValue: _initialStringTextEditingController.text,
    );
    _textProcessorController.addListener(_textProcessorControllerListener);

    final textProcessor = TextProcessor(controller: _textProcessorController);
    final invoker = TextProcessorCommandInvoker();
    final parser = TextProcessorCommandParser(
      textProcessor: textProcessor,
      undoCallback: invoker.undo,
      redoCallback: invoker.redo,
    );

    try {
      invoker.process(parser.parseLines(
        _commandsTextEditingController.text.split('\n'),
      ));

      _resultStringTextEditingController.text =
          _textProcessorController.value.text;
    } catch (error, stackTrace) {
      _resultStringTextEditingController.text = '';
      _logsTextEditingController.text += '$error\n';

      dev.log(
        'Houston, we have a problem.',
        error: error,
        stackTrace: stackTrace,
      );
    }

    _textProcessorController.removeListener(_textProcessorControllerListener);
  }

  @override
  void initState() {
    _textProcessorController = ListenableTextProcessorController();
    _initialStringTextEditingController = TextEditingController();
    _commandsTextEditingController = TextEditingController();
    _logsTextEditingController = TextEditingController();
    _resultStringTextEditingController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _textProcessorController.dispose();
    _initialStringTextEditingController.dispose();
    _commandsTextEditingController.dispose();
    _logsTextEditingController.dispose();
    _resultStringTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _initialStringTextEditingController,
                    decoration: const InputDecoration(
                      labelText: 'Initial String',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: _onLoadStringPressed,
                  color: colorScheme.primaryContainer,
                  child: Text(
                    'Load String',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onPrimaryContainer),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.top,
                            expands: true,
                            controller: _commandsTextEditingController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: const InputDecoration(
                              labelText: 'Commands',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          onPressed: _onLoadCommandsPressed,
                          color: colorScheme.primaryContainer,
                          child: Text(
                            'Load Commands',
                            style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onPrimaryContainer),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.top,
                            expands: true,
                            controller: _logsTextEditingController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Logs',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          onPressed: _onClearLogsPressed,
                          color: colorScheme.primaryContainer,
                          child: Text(
                            'Clear Logs',
                            style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onPrimaryContainer),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _resultStringTextEditingController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Result String',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: _onProcessPressed,
                  color: colorScheme.primary,
                  child: Text(
                    'Process',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onPrimary),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ValueListenableBuilder(
                  valueListenable: _resultStringTextEditingController,
                  builder: (context, value, child) => MaterialButton(
                    onPressed: value.text.isEmpty ? null : _onSaveStringPressed,
                    color: colorScheme.primaryContainer,
                    child: child,
                  ),
                  child: Text(
                    'Save String',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: colorScheme.onPrimaryContainer),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
