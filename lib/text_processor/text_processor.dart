import 'dart:developer' as dev;
import 'dart:io';

import 'package:equatable/equatable.dart';

import '../pattern.dart';
import '../exceptions.dart';
import '../utils/stack.dart';
import '../utils/types.dart';

part 'text_processor_command_invoker.dart';
part 'text_processor_command_parser.dart';
part 'text_processor_controller.dart';
part 'text_processor_state.dart';

/// Commands
part 'text_processor_commands/text_processor_copy_command.dart';
part 'text_processor_commands/text_processor_delete_command.dart';
part 'text_processor_commands/text_processor_insert_command.dart';
part 'text_processor_commands/text_processor_paste_command.dart';
part 'text_processor_commands/text_processor_redo_command.dart';
part 'text_processor_commands/text_processor_undo_command.dart';

final class TextProcessor<Controller extends TextProcessorController>
    extends Receiver {
  TextProcessor({required Controller controller}) : _controller = controller;

  final Controller _controller;

  /// shortcuts
  TextProcessorState get _state => _controller.value;
  set _state(TextProcessorState state) => _controller.value = state;

  void copy(int idx1, int idx2) {
    var isValid = idx2 > idx1;
    isValid &= idx1 >= 0;
    isValid &= idx2 >= 0;
    isValid &= idx1 <= _state.text.length;
    isValid &= idx2 <= _state.text.length;

    if (!isValid) {
      throw OutOfRangeException(
          'error copy: idx (idx1: ${idx1 + 1}, idx2: ${idx2 + 1}) '
          'out of range [1..${_state.text.length + 1}]');
    }

    if (_state.text.isEmpty) {
      /// Nothing to copy
      return;
    }

    final buffer = _state.text.substring(idx1, idx2);

    _state = _state.copyWith(buffer: buffer);
  }

  void delete(int idx1, int idx2) {
    var isValid = idx2 > idx1;
    isValid &= idx1 >= 0;
    isValid &= idx2 >= 0;
    isValid &= idx1 <= _state.text.length;
    isValid &= idx2 <= _state.text.length;

    if (!isValid) {
      throw OutOfRangeException('error delete: idx (idx1: ${idx1 + 1}, '
          'idx2: ${idx2 + 1}) out of range [1..${_state.text.length + 1}]');
    }

    if (_state.text.isEmpty) {
      /// Nothing to delete
      return;
    }

    final start = _state.text.substring(0, idx1);
    final end = _state.text.substring(idx2);
    final text = start + end;

    _state = _state.copyWith(text: text);
  }

  void insert(String string, int idx) {
    var isValid = idx >= 0;
    isValid &= idx <= _state.text.length;

    if (!isValid) {
      throw OutOfRangeException('error insert: idx ${idx + 1} '
          'out of range [1..${_state.text.length + 1}]');
    }

    if (string.isEmpty) {
      /// Nothing to insert
      return;
    }

    final start = _state.text.substring(0, idx);
    final end = _state.text.substring(idx);
    final text = start + string + end;

    _state = _state.copyWith(text: text);
  }

  void paste(int idx) {
    var isValid = idx >= 0;
    isValid &= idx <= _state.text.length;

    if (!isValid) {
      throw OutOfRangeException('error paste: idx ${idx + 1} '
          'out of range [1..${_state.text.length + 1}]');
    }

    if (_state.buffer.isEmpty) {
      /// Nothing to paste
      return;
    }

    final start = _state.text.substring(0, idx);
    final end = _state.text.substring(idx);
    final text = start + _state.buffer + end;

    _state = _state.copyWith(text: text);
  }

  void _restore(TextProcessorState state) {
    if (_state == state) {
      /// Nothing to restore
      return;
    }

    _state = state;
  }
}
