final class OutOfRangeException implements Exception {
  final String? message;

  OutOfRangeException([this.message]);

  @override
  String toString() => message ?? 'OutOfRangeException';
}

final class InvalidStateException implements Exception {
  final String? message;

  InvalidStateException([this.message]);

  @override
  String toString() => message ?? 'InvalidStateException';
}

final class InvalidInputException implements Exception {
  final String? message;

  InvalidInputException([this.message]);

  @override
  String toString() => message ?? 'InvalidInputException';
}

final class InvalidArgumentsException implements Exception {
  final String? message;

  InvalidArgumentsException([this.message]);

  @override
  String toString() => message ?? 'InvalidArgumentsException';
}

final class UnknownCommandException implements Exception {
  final String? message;

  UnknownCommandException([this.message]);

  @override
  String toString() => message ?? 'UnknownCommandException';
}
