import 'dart:developer' as dev;
import 'dart:io';

import 'package:equatable/equatable.dart';

import '../pattern.dart';
import '../exceptions.dart';
import '../utils/stack.dart';
import '../utils/types.dart';

part 'text_processor_command_invoker.dart';
part 'text_processor_command_parser.dart';
part 'text_processor_commands/text_processor_copy_command.dart';
part 'text_processor_commands/text_processor_delete_command.dart';
part 'text_processor_commands/text_processor_insert_command.dart';
part 'text_processor_commands/text_processor_paste_command.dart';
part 'text_processor_commands/text_processor_redo_command.dart';
part 'text_processor_commands/text_processor_undo_command.dart';
part 'text_processor_state.dart';

class TextProcessor implements Receiver {
  TextProcessor(TextProcessorState initialState) : __state = initialState;

  TextProcessorState __state;

  TextProcessorState get _state => __state;
  set _state(TextProcessorState state) {
    dev.log('Old: $__state\n New: $state\n');

    __state = state;
  }

  String get value => __state.value;

  void copy(int idx1, int idx2) {
    var isValid = idx2 >= idx1;
    isValid &= idx1 > -1;
    isValid &= idx2 > -1;
    isValid &= idx1 < _state.value.length;
    isValid &= idx2 < _state.value.length;

    if (!isValid) throw OutOfBoundsException();

    if (_state.value.isEmpty) {
      /// Nothing to copy
      return;
    }

    final buffer = _state.value.substring(idx1, idx2);

    _state = _state.copyWith(buffer: buffer);
  }

  void delete(int idx1, int idx2) {
    var isValid = idx2 >= idx1;
    isValid &= idx1 > -1;
    isValid &= idx2 > -1;
    isValid &= idx1 < _state.value.length;
    isValid &= idx2 < _state.value.length;

    if (!isValid) throw OutOfBoundsException();

    if (_state.value.isEmpty) {
      /// Nothing to delete
      return;
    }

    final start = _state.value.substring(0, idx1);
    final end = _state.value.substring(idx2);
    final value = start + end;

    _state = _state.copyWith(value: value);
  }

  void insert(String string, int idx) {
    var isValid = idx > -1;
    isValid &= idx < _state.value.length;

    if (!isValid) throw OutOfBoundsException();

    if (string.isEmpty) {
      /// Nothing to insert
      return;
    }

    final start = _state.value.substring(0, idx);
    final end = _state.value.substring(idx);
    final value = start + string + end;

    _state = _state.copyWith(value: value);
  }

  void paste(int idx) {
    var isValid = idx > -1;
    isValid &= idx < _state.value.length;

    if (!isValid) throw OutOfBoundsException();

    if (_state.buffer.isEmpty) {
      /// Nothing to paste
      return;
    }

    final start = _state.value.substring(0, idx);
    final end = _state.value.substring(idx);
    final value = start + _state.buffer + end;

    _state = _state.copyWith(value: value);
  }

  void _restore(TextProcessorState state) {
    if (_state == state) {
      /// Nothing to restore
      return;
    }

    _state = state;
  }
}
