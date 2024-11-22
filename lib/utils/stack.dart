import 'dart:collection';

abstract interface class Stack<T> {
  factory Stack() => _StackImpl<T>();

  bool get isEmpty;
  bool get isNotEmpty;

  T pop();
  void push(T command);
  void clear();
}

class _StackImpl<T> implements Stack<T> {
  _StackImpl();

  final Queue<T> _queue = Queue();

  @override
  bool get isEmpty => _queue.isEmpty;

  @override
  bool get isNotEmpty => _queue.isNotEmpty;

  @override
  T pop() => _queue.removeLast();

  @override
  void push(T value) => _queue.addLast(value);

  @override
  void clear() => _queue.clear();
}
