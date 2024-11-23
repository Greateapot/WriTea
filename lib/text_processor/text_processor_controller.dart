part of 'text_processor.dart';

abstract interface class TextProcessorController {
  factory TextProcessorController(TextProcessorState initialState) =>
      _TextProcessorControllerImpl(initialState);

  set value(TextProcessorState value);
  TextProcessorState get value;
}

final class _TextProcessorControllerImpl implements TextProcessorController {
  _TextProcessorControllerImpl(TextProcessorState initialState)
      : _value = initialState;

  TextProcessorState _value;

  @override
  TextProcessorState get value => _value;

  @override
  set value(TextProcessorState value) => _value = value;
}
