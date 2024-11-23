part of 'text_processor.dart';

class TextProcessorState extends Equatable {
  final String text;
  final String buffer;

  const TextProcessorState({
    required this.text,
    required this.buffer,
  });

  factory TextProcessorState.empty() =>
      const TextProcessorState(text: "", buffer: "");

  factory TextProcessorState.value(String text) =>
      TextProcessorState(text: text, buffer: "");

  TextProcessorState copyWith({String? text, String? buffer}) =>
      TextProcessorState(
        text: text ?? this.text,
        buffer: buffer ?? this.buffer,
      );

  @override
  List<Object?> get props => [text, buffer];
}
