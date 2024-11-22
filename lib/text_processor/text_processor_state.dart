part of 'text_processor.dart';

class TextProcessorState implements Equatable {
  final String value;
  final String buffer;

  const TextProcessorState({
    required this.value,
    required this.buffer,
  });

  factory TextProcessorState.empty() =>
      const TextProcessorState(value: "", buffer: "");

  factory TextProcessorState.value(String value) =>
      TextProcessorState(value: value, buffer: "");

  @override
  List<Object?> get props => [value, buffer];

  @override
  bool? get stringify => false;

  TextProcessorState copyWith({String? value, String? buffer}) =>
      TextProcessorState(
        value: value ?? this.value,
        buffer: buffer ?? this.buffer,
      );

  @override
  String toString() => 'TextProcessorState(value: "$value", buffer: "$buffer")';
}
