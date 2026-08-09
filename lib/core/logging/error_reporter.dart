import 'dart:async';

abstract interface class ErrorReporter {
  Future<void> report(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    Map<String, Object>? metadata,
    bool fatal = false,
  });
}
